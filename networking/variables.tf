variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for private subnet"
  default     = "10.0.50.0/24"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_flow_bucket_name" {
  type        = string
  description = "S3 bucket name for VPC flow logs"
  default     = "my-vpc-flow-logs-bucket"
}