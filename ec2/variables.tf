variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "private_subnet_id" {
  type    = string
  default = "insert subnet id"
}

variable "vpc_id" {
  type    = string
  default = "insert vpc id"
}

variable "ami_id" {
  type    = string
  default = "ami-xxxxx"
}

variable "iam_role_name" {
  type    = string
  default = "ec2-ssm-role"
}

variable "region" {
  type    = string
  default = "us-west-2"
}