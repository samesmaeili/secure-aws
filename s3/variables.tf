variable "bucket_name" {
  type        = string
  description = "Name of the secure S3 bucket"
  default     = "secure-s3-bucket"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID"
  default     = "123456789"
}

variable "region" {
  type    = string
  default = "us-west-2"
}