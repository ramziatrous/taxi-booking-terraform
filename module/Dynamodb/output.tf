output "latest_stream_arn" {
  value = aws_dynamodb_table.drivers.stream_arn
}
output "dynamodb_arn" {
  value = aws_dynamodb_table.drivers.arn
}
