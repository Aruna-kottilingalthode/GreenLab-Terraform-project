variable "instance_type" {
  type = string
}

variable "kali_ami" {
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

variable "kali_iam_instance_profile" {
  type        = string
  description = "IAM instance profile for EC2 to use CloudWatch"
}

