resource "aws_instance" "web_app" {
  ami                    = "ami-12345678" # Update with your desired AMI ID
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnet_id
  vpc_security_group_ids = [aws_security_group.public_web.id]

  tags = {
    Name = "ministack-web-app"
  }
}

output "web_app_ip" {
  description = "Public IP of the web application instance"
  value       = aws_instance.web_app.public_ip
}