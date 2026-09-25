output "table_name" {
  description = "Name of the DynamoDB application locks table"
  value       = aws_dynamodb_table.app_locks.name
}