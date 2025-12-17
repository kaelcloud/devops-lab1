# Terraform configuration file untuk provision AWS infrastructure
# HCL (HashiCorp Configuration Language) - declarative language

# Specify Terraform version dan AWS provider version
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = var.aws_region
  # Explanation: Provider ni macam plugin yang allow Terraform interact dengan AWS API
  # Region specify kat mana infrastructure akan deploy (e.g., ap-southeast-1 for Singapore)
}

# Data source untuk get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu official)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
# Explanation: Data source ni query AWS untuk get info, bukan create resource.
# Kita cari latest Ubuntu 22.04 AMI. AMI (Amazon Machine Image) macam template untuk EC2 instance.

# Security Group - firewall rules untuk EC2
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for web server"

  # Ingress rule - incoming traffic
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from anywhere
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict to your IP only
  }

  # Egress rule - outgoing traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}
# Explanation: Security Group ni macam firewall untuk EC2.
# Ingress = masuk (inbound), Egress = keluar (outbound)
# Port 80 untuk HTTP, Port 22 untuk SSH
# cidr_blocks ["0.0.0.0/0"] = allow dari mana-mana IP (not recommended for production)

# EC2 Instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.deployer.key_name  # ADD THIS LINE

  # User data script - runs when instance first boots
  user_data = <<-EOF
              #!/bin/bash
              # Update system
              apt-get update
              apt-get upgrade -y
              
              # Install Docker
              apt-get install -y ca-certificates curl gnupg lsb-release
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt-get update
              apt-get install -y docker-ce docker-ce-cli containerd.io
              
              # Start Docker service
              systemctl start docker
              systemctl enable docker
              
              # Add ubuntu user to docker group
              usermod -aG docker ubuntu
              
              # Create deployment directory
              mkdir -p /home/ubuntu/app
              chown ubuntu:ubuntu /home/ubuntu/app
              EOF

  tags = {
    Name = "${var.project_name}-server"
  }
}
# Explanation: 
# EC2 Instance ni virtual server dalam AWS
# user_data runs once masa instance first start (bootstrap script)
# Script ni install Docker dan setup environment
# <<-EOF ... EOF ni heredoc syntax, allow multi-line strings

# Elastic IP - static public IP
resource "aws_eip" "web_eip" {
  instance = aws_instance.web_server.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}
# Explanation: By default, EC2 public IP akan change bila restart.
# Elastic IP ni static IP yang persist even bila instance stop/start.
# Penting untuk production supaya DNS/endpoint tak berubah.

# Outputs - display values after terraform apply
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.web_eip.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.web_server.public_dns
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://${aws_eip.web_eip.public_ip}"
}