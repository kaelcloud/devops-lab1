# SSH Key Pair for EC2 access
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-key"
  public_key = var.ssh_public_key
  
  tags = {
    Name = "${var.project_name}-key"
  }
}