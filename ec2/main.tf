# Security Group for EC2 Instance (onlly allow egress)
resource "aws_security_group" "instance_sg" {
  name        = "secure-instance-sg"
  description = "Security group for secure EC2 instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secure-instance-sg"
  }
}

# Instance Profile to use SSM to remote into server
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2-ssm-profile"
  role = var.iam_role_name
}

# EC2 Instance with encrypted volume and imdsv2 enabled
resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  monitoring = true

  tags = {
    Name = "private-secure-instance"
  }

  lifecycle {
    prevent_destroy = true
  }
}


