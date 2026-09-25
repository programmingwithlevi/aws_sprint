resource "aws_instance" "app_server" {
  ami           = "ami-12345678"
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
module "vpc" {
  source = "./modules/vpc"
}
module "database" {
  source      = "./modules/database"
  table_name  = "ministack-app-locks"
  environment = "development"
}