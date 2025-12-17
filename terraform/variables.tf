# Variables definition file
# Variables allow reusable and configurable Terraform code

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-5"  # Malaysia region
}
# Explanation: Variable ni define parameter yang boleh customize.
# type = string enforce that value must be string
# default = fallback value if not provided

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "devops-lab1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"  # Free tier eligible
}
# Explanation: t2.micro ni smallest instance type, covered by AWS free tier
# 1 vCPU, 1GB RAM - cukup untuk simple applications