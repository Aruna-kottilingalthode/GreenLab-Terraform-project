variable "instance_type" {
  type = string
}

variable "jumpbox_ami" {
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

variable "ad_private_ip" {
  description = "Private IP of the AD server for resolver"
  type        = string
}

variable "ad_domain" {
  type        = string
  description = "Active Directory domain name"
}

variable "ad_realm" {
  type        = string
  description = "Active Directory realm (usually uppercase domain)"
}

variable "secret_arn" {
  type        = string
  description = "ARN of the AD admin password secret in Secrets Manager"
}

variable "region" {
  type        = string
  description = "AWS region for the Jumpbox"
}

variable "user_data" {
  type        = string
  description = "Userdata script for Jumpbox instance"
  default     = ""
}

variable "jumpbox_iam_instance_profile" {
  type        = string
  description = "IAM instance profile for EC2 to use CloudWatch"
}


