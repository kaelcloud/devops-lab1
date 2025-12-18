# Variables definition file
# Variables allow reusable and configurable Terraform code

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-1"  # Singapore region
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
  default     = "t3.micro"  # Free tier eligible
}
# Explanation: t2.micro ni smallest instance type, covered by AWS free tier
# 1 vCPU, 1GB RAM - cukup untuk simple applications

variable "ssh_public_key" {
  description = "SSH public key for EC2 access"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAtdwTNkA7eoKvKIb6j/OU/xbqpPP8dCr9pDPZmF28HxFQhZCJ0gNZfRkhMiNyBUmZy4DyY6MvWlY1C4bFlhlKYmzuPf8P1L7WpQPySQoQ9W+aboTpu+ueYSTySOWmzf+tQGDFdffxROdPPPFo4Gqe16WVFqACmnqkCBn2UluERFncQzytqqE5FNLAEc4qlSS1KkWJG9XHmklyWgpdJoBn4uxq5V4+grzTq8jCDAWjVAS774FgjSok01SvoWVCT7bj/qRP1F+u8cbhJ5oIHhX+QvpVcRl4f0TtpJL6ETNZwNFjk6GyJTEDyzT7lUDRCz23StvTxZ/alr5UWJfXu/XGl8ysLYy79tPRTipvsEWd3X5UK7F/l0xSZCZU/jjlmX9EpADDeDd2N7rYKCsrLiSOequaS4QMNt6o9mli6p+a7l/eVfpQ+6y52n/pWVXY1oK4mg196W2W82yypngGAYDm9vNoZMeBcTvyW4SE2WjtOxpHufQCuSrUxvFIIVqT9eyufaoQP/GPG5hnYVlpdC3s13GyJpWVm0rS7kdbXcHjcAzRt1R4n1KoQtLQ9BkbGCJ4SHcQ7DfFbk4j47vGQlUjW0lI+bjUX0iODwPKPUyJQrAdrLnBRutfRRKPZZrXvdVi1W9lP+Jslb87R+Mrc3KL3CqGj36C6hd3sN7ovPmjQw== user@PCAX019"
}