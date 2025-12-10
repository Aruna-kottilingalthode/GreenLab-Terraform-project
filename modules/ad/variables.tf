variable "instance_type" {
  type = string
}

variable "ad_ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "user_data" {
  type = string
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile for AD Server (SSM + CloudWatch)"
}

variable "secret_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "cw_windows_document_name" {
  type        = string
  description = "Name of the Windows CloudWatch SSM Document"
}



