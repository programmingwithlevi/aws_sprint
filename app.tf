resource "aws_instance" "web_app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnets[0]

  tags = {
    Name          = "ministack-web-app"
    DatabaseTable = module.database.dynamodb_table_id
  }
}