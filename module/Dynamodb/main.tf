resource "aws_dynamodb_table" "drivers" {
  name             = var.table_name
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "fahrer_Id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  attribute {
    name = "fahrer_Id"
    type = "S"
  }
  attribute {
    name = "booking_id"
    type = "S"
  }
  global_secondary_index {
    name            = "booking_id-index"
    hash_key        = "booking_id"
    projection_type = "ALL"
    write_capacity  = 5
    read_capacity   = 5
  }
}

resource "aws_dynamodb_table_item" "driver" {
  table_name = aws_dynamodb_table.drivers.name
  hash_key   = aws_dynamodb_table.drivers.hash_key

  item = <<ITEM
{
  "fahrer_Id": {"S": "1"},
  "booking_id": {"S": "1"},
  "available": {"BOOL": true},
  "client_name": {"S": ""},
  "name": {"S": "ingo"}
}
ITEM
}