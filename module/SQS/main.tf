resource "aws_sqs_queue" "tf_queue" {
  count                     = length(var.sqs_name)
  name                      = var.sqs_name[count.index]
  delay_seconds             = var.delay_seconds[count.index]
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
  tags = {
    Environment = var.Environment
  }
}
