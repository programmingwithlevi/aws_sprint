variable "aws_account_id" {
  type    = string
  default = "000000000000" # MiniStack fallback default
}

variable "aws_region_name" {
  type    = string
  default = "us-east-1"
}

# 1. The Trust Policy (AssumeRole) for our EC2 compute tier
resource "aws_iam_role" "app_compute_role" {
  name = "ministack-app-compute-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 2. Least-Privilege Policy for Parameter Store (No wildcards!)
resource "aws_iam_policy" "app_ssm_policy" {
  name        = "ministack-app-ssm-policy"
  description = "Allows compute tier to read only the production database password parameter"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ssm:GetParameter"
        Resource = "arn:aws:ssm:${var.aws_region_name}:${var.aws_account_id}:parameter/ministack/prod/db_password"
      }
    ]
  })
}

# 3. Bind the policy to the role
resource "aws_iam_role_policy_attachment" "app_attachment" {
  role       = aws_iam_role.app_compute_role.name
  policy_arn = aws_iam_policy.app_ssm_policy.arn
}

# 4. Instance Profile wrapper for EC2 attachment
resource "aws_iam_instance_profile" "app_profile" {
  name = "ministack-app-instance-profile"
  role = aws_iam_role.app_compute_role.name
}