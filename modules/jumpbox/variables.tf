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

variable "user_data" {
  type        = string
  description = "Userdata script for Jumpbox instance"
  default     = ""
}

variable "jumpbox_iam_instance_profile" {
  type        = string
  description = "IAM instance profile for EC2 to use CloudWatch"
}


