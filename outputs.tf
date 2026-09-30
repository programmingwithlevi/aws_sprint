output "instance_hostname" {
  value = aws_instance.web_app.private_dns
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "database_table_name" {
  value = module.database.dynamodb_table_id
}