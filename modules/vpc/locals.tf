data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Restrict deployment to the first 2 availability zones for high availability
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  # Base VPC CIDR is passed in via variable (e.g., "10.0.0.0/16")
  # We use a 4-bit extension (newbits = 4) which gives us /20 subnets.
  # Tier offsets ensure zero overlap:
  # Public:   netnum 0, 1
  # Private:  netnum 2, 3
  # Database: netnum 4, 5
}