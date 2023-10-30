resource "aws_apigatewayv2_api" "Taxi" {
  name          = var.api_name
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_headers = ["*"]
    allow_methods = ["POST", "GET"]
  }
}
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.Taxi.id
  name        = "$default"
  auto_deploy = true
}



resource "aws_apigatewayv2_integration" "booking_status_integration" {
  api_id             = aws_apigatewayv2_api.Taxi.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = var.status_invoke_arn
}
resource "aws_apigatewayv2_route" "booking_status_route" {
  api_id    = aws_apigatewayv2_api.Taxi.id
  route_key = "GET /get/{booking_id}"
  target    = "integrations/${aws_apigatewayv2_integration.booking_status_integration.id}"
}




resource "aws_lambda_permission" "allow_api_gateway_to_invoke_booking_status" {
  statement_id  = "AllowAPIGatewayInvokeAdd"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn[1]
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.Taxi.execution_arn}/*/*/get/{booking_id}"
}





resource "aws_iam_role" "api_gateway_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "sqs_policy" {

  name = var.sqs_policy_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "sqs:SendMessage",
        "Resource" : var.sqs_arn_booking
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : "sqs:ListQueues",
        "Resource" : "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "api_gateway_attachment" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = aws_iam_policy.sqs_policy.arn
}

resource "aws_apigatewayv2_integration" "booking_integration" {
  api_id              = aws_apigatewayv2_api.Taxi.id
  credentials_arn     = aws_iam_role.api_gateway_role.arn
  description         = "SQS "
  integration_type    = "AWS_PROXY"
  integration_subtype = "SQS-SendMessage"

  request_parameters = {
    "QueueUrl"    = var.sqs_url
    "MessageBody" = "$request.body"
  }
}

resource "aws_apigatewayv2_route" "booking_route" {
  api_id    = aws_apigatewayv2_api.Taxi.id
  route_key = "POST /post"
  target    = "integrations/${aws_apigatewayv2_integration.booking_integration.id}"
}