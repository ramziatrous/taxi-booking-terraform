resource "aws_sns_topic" "sns_topic" {
  name = var.name
}
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = "ramzi.atrous@docc.techstarter.de"
}