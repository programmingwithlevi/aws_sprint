output "instance_hostname" {
  description = "Private DNS name of the EC2 instance."
  value       = aws_instance.app_server.private_dns
}

output "vpc_id" {
  description = "The ID of the custom VPC."
  value       = module.vpc.vpc_id
}