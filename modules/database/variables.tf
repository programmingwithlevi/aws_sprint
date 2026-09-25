variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "ministack-app-locks"
}

variable "environment" {
  description = "Deployment environment tag"
  type        = string
  default     = "development"
}