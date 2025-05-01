# IAM Role for EC2 Instance
resource "aws_iam_role" "ssm_role" {
  name = "ec2-ssm-role"

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

# Attach SSM Policy
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_s3_bucket" "secure-bucket" {
  bucket = var.bucket_name
}

# Add S3 read-write access to EC2 role
resource "aws_iam_role_policy" "s3_read_access" {
  name = "s3-read-write-access"
  role = aws_iam_role.ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
        ]
        Resource = [
          data.aws_s3_bucket.secure-bucket.arn,
          "${data.aws_s3_bucket.secure-bucket.arn}/*"
        ]
      }
    ]
  })
}

# OIDC Provider for Terraform Cloud
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url = "https://app.terraform.io"

  client_id_list = ["aws.workload.identity"]

  thumbprint_list = [
    "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
  ]
}

# IAM Role for Terraform Cloud
resource "aws_iam_role" "tfc_role" {
  name = "terraform-cloud-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.tfc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "app.terraform.io:aud" : "aws.workload.identity"
          }
          StringLike = {
            "app.terraform.io:sub" : "organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}:run_phase:*"
          }
        }
      }
    ]
  })
}

# Add required permissions to the role
resource "aws_iam_role_policy_attachment" "tfc_policy" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Adjust based on needs
}
