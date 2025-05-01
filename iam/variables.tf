variable "bucket_name" {
  type        = string
  description = "ARN of the S3 bucket to grant access to"
  default     = "secure-s3-bucket"
}

variable "tfc_organization_name" {
  type        = string
  description = "Terraform Cloud organization name"
  default     = "test-organization"
}

variable "tfc_project_name" {
  type        = string
  description = "Terraform Cloud project name"
  default     = "secure-aws"
}

variable "tfc_workspace_name" {
  type        = string
  description = "Terraform Cloud workspace name"
  default     = "secure-aws"
}

variable "region" {
  type    = string
  default = "us-west-2"
}