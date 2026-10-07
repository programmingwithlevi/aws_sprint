resource "aws_instance" "web_app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  subnet_id = module.vpc.public_subnets[0]
#  vpc_security_group_ids = [aws_security_group.public_web.id]

  tags = {
    Name          = "ministack-web-app"
    DatabaseTable = "ministack-table"
    Environment   = "dev"
    Owner         = "platform-team"
    ManagedBy     = "terraform"
  }
}