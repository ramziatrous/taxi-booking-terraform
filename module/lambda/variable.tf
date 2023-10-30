variable "filename" {
  type    = list(string)
  default = ["booking.zip", "status.zip", "waiting.zip"]
}
variable "function_name" {
  type    = list(string)
  default = ["tf_booking", "tf_booking_status", "tf_waiting_liste"]
}

variable "runtime" {
  type    = string
  default = "nodejs18.x"
}

variable "handler" {
  type    = string
  default = "index.handler"
}

variable "sqs_arn" {

}

variable "role_name" {
  type    = list(string)
  default = ["lambda_role", "lambda_role2", "lambda_role3"]
}

variable "cloudwatch_policy_name" {
  type    = list(string)
  default = ["cloudwatch_policy1", "cloudwatch_policy2", "cloudwatch_policy3"]
}

variable "sqs_policy_name" {
  type    = list(string)
  default = ["sqs_booking_policy", "sqs_waiting_policy"]
}

variable "dynamodb_policy_name" {
  default = "dynamodb"
}

variable "dynamodb_arn" {

}



variable "dynamodb_index_policy_name" {
  default = "dynamodb_index"
}

variable "dynamodb_stream_policy_name" {
  default = "dynamodb_stream"
}

variable "latest_stream_arn" {

}

variable "sns_policy_name" {
  default = "sns"
}

variable "sns_arn" {

}