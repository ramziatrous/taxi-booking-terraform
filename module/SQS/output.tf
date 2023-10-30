output "sqs_arn" {
  value = aws_sqs_queue.tf_queue.*.arn
}
output "sqs_arn_booking" {
  value = aws_sqs_queue.tf_queue[0].arn
}
output "sqs_url" {
  value = aws_sqs_queue.tf_queue[0].url
}