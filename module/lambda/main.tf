locals {
  account_number = {account_number}
}
resource "aws_iam_role" "lambda_role" {
  count = 3
  name  = var.role_name[count.index]
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Effect : "Allow",
        Principal : {
          Service : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "sns_policy" {
  name = var.sns_policy_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sns:Publish",
        "Resource" : var.sns_arn
      }
    ]
  })
}
resource "aws_iam_policy" "dynamodb_policy" {
  name = var.dynamodb_policy_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:ListContributorInsights",
          "dynamodb:DescribeReservedCapacityOfferings",
          "dynamodb:ListGlobalTables",
          "dynamodb:ListTables",
          "dynamodb:DescribeReservedCapacity",
          "dynamodb:ListBackups",
          "dynamodb:PurchaseReservedCapacityOfferings",
          "dynamodb:ListImports",
          "dynamodb:DescribeLimits",
          "dynamodb:DescribeEndpoints",
          "dynamodb:ListExports",
          "dynamodb:ListStreams"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : "dynamodb:*",
        "Resource" : var.dynamodb_arn
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_index_policy" {
  name = var.dynamodb_index_policy_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "dynamodb:Query",
        "Resource" : "${var.dynamodb_arn}/index/booking_id-index"
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_stream_policy" {
  name = var.dynamodb_stream_policy_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:BatchGetItem",
          "dynamodb:DescribeImport",
          "dynamodb:ConditionCheckItem",
          "dynamodb:DescribeContributorInsights",
          "dynamodb:Scan",
          "dynamodb:ListTagsOfResource",
          "dynamodb:Query",
          "dynamodb:DescribeStream",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:DescribeGlobalTableSettings",
          "dynamodb:PartiQLSelect",
          "dynamodb:DescribeTable",
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeGlobalTable",
          "dynamodb:GetItem",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:DescribeExport",
          "dynamodb:DescribeKinesisStreamingDestination",
          "dynamodb:DescribeBackup",
          "dynamodb:GetRecords",
          "dynamodb:DescribeTableReplicaAutoScaling"
        ],
        "Resource" : var.latest_stream_arn
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:DescribeReservedCapacityOfferings",
          "dynamodb:DescribeReservedCapacity",
          "dynamodb:DescribeLimits",
          "dynamodb:DescribeEndpoints",
          "dynamodb:ListStreams"
        ],
        "Resource" : "*"
      }
    ]
  })
}
resource "aws_iam_policy" "sqs_policy" {
  count = 2
  name  = var.sqs_policy_name[count.index]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "sqs:ListQueues",
        "Resource" : "*"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : "sqs:*",
        "Resource" : var.sqs_arn[count.index]
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_policy" {
  count = 3
  name  = var.cloudwatch_policy_name[count.index]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "logs:CreateLogGroup",
        "Resource" : "arn:aws:logs:eu-central-1:${local.account_number}:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:eu-central-1:${local.account_number}:log-group:/aws/lambda/${aws_lambda_function.lambda[count.index].function_name}:*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "sns_booking_policy_attachment" {
  policy_arn = aws_iam_policy.sns_policy.arn
  role       = aws_iam_role.lambda_role[0].name
}
resource "aws_iam_role_policy_attachment" "sns_waiting_policy_attachment" {
  policy_arn = aws_iam_policy.sns_policy.arn
  role       = aws_iam_role.lambda_role[2].name
}
resource "aws_iam_role_policy_attachment" "sqs_booking_policy_attachment" {

  policy_arn = aws_iam_policy.sqs_policy[0].arn
  role       = aws_iam_role.lambda_role[0].name
}

resource "aws_iam_role_policy_attachment" "sqs_waiting_policy_attachment" {
  count      = 3
  policy_arn = aws_iam_policy.sqs_policy[1].arn
  role       = aws_iam_role.lambda_role[count.index].name
}
resource "aws_iam_role_policy_attachment" "dynamodb_stream_policy_attachment" {
  policy_arn = aws_iam_policy.dynamodb_stream_policy.arn
  role       = aws_iam_role.lambda_role[2].name
}
resource "aws_iam_role_policy_attachment" "dynamodb_index_policy_attachment" {
  policy_arn = aws_iam_policy.dynamodb_index_policy.arn
  role       = aws_iam_role.lambda_role[1].name
}
resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  count      = 3
  policy_arn = aws_iam_policy.dynamodb_policy.arn
  role       = aws_iam_role.lambda_role[count.index].name
}
resource "aws_iam_role_policy_attachment" "lambda_cw_attachment" {
  count      = 3
  policy_arn = aws_iam_policy.cloudwatch_policy[count.index].arn
  role       = aws_iam_role.lambda_role[count.index].name
}

resource "aws_lambda_function" "lambda" {
  count         = length(var.function_name)
  filename      = var.filename[count.index]
  function_name = var.function_name[count.index]
  handler       = var.handler
  runtime       = var.runtime
  role          = aws_iam_role.lambda_role[count.index].arn

}


resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = var.sqs_arn[0]
  function_name    = aws_lambda_function.lambda[0].arn
  depends_on       = [aws_iam_policy.sqs_policy, aws_iam_role_policy_attachment.sqs_booking_policy_attachment]
}

resource "aws_lambda_event_source_mapping" "sqs1_trigger" {
  event_source_arn = var.sqs_arn[1]
  function_name    = aws_lambda_function.lambda[2].arn
  depends_on       = [aws_iam_policy.sqs_policy, aws_iam_role_policy_attachment.sqs_waiting_policy_attachment]
}

resource "aws_lambda_event_source_mapping" "dynamodb_trigger" {
  event_source_arn  = var.latest_stream_arn
  function_name     = aws_lambda_function.lambda[2].arn
  starting_position = "LATEST"
  depends_on        = [aws_iam_policy.dynamodb_stream_policy, aws_iam_role_policy_attachment.dynamodb_stream_policy_attachment]
}