variable "sqs_name" {
  type    = list(string)
  default = ["tf_booking", "tf_waiting_liste"]
}
variable "delay_seconds" {
  type    = list(string)
  default = ["0", "5"]
}

variable "max_message_size" {
  default = "1024"
}

variable "message_retention_seconds" {
  default = "86400"
}

variable "receive_wait_time_seconds" {
  default = "0"
}

variable "Environment" {
  default = "production"
}