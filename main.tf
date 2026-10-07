# VPC Module (Satisfies module.vpc.vpc_id)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "ministack-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = false
}

# Compute Instance (Satisfies aws_instance.app_server)
resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.private_subnets[0]

  tags = {
    Name = "ministack-app-server"
  }
}

# Database Module (Satisfies module.database.table_name)
module "database" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 4.0"

  name     = "ministack-table"
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}