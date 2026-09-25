resource "aws_dynamodb_table" "app_locks" {
  name         = "ministack-app-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockId"

  attribute {
    name = "LockId"
    type = "S"
  }

  tags = {
    Environment = "development"
    Project     = "ministack"
  }
}