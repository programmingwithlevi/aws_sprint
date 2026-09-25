resource "aws_instance" "web_app" {
  ami                    = "ami-12345678"
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnet_id
  vpc_security_group_ids = [aws_security_group.public_web.id]

  tags = {
    Name          = "ministack-web-app"
    Environment   = "development"
    DatabaseTable = module.database.table_name
  }

  lifecycle {
    create_before_destroy = true
  }
}