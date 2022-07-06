resource "aws_dynamodb_table" "this" {
  name           = "http-crud-tutorial-items"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
  tags = local.tags
}