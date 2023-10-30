output "lambda_arn" {
  value = aws_lambda_function.lambda.*.arn

}
output "status_invoke_arn" {
  value = aws_lambda_function.lambda[1].invoke_arn
}
