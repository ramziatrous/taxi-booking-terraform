module "DB_table" {
  source = "./module/Dynamodb"
}
module "S3" {
  source = "./module/S3"
}
module "sqs" {
  source = "./module/SQS"
}
module "sns" {
  source = "./module/SNS"
}
module "lambda" {
  source            = "./module/lambda"
  sqs_arn           = module.sqs.sqs_arn
  dynamodb_arn      = module.DB_table.dynamodb_arn
  latest_stream_arn = module.DB_table.latest_stream_arn
  sns_arn           = module.sns.sns_arn
}

module "apigateway" {
  source            = "./module/ApiGateway"
  lambda_arn        = module.lambda.lambda_arn
  sqs_arn_booking   = module.sqs.sqs_arn_booking
  status_invoke_arn = module.lambda.status_invoke_arn
  sqs_url           = module.sqs.sqs_url
}
