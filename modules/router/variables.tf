variable "instance_type" {
  type = string
}

variable "router_ami" {
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
  default = ""
}

variable "router_iam_instance_profile" {
  type        = string
  description = "IAM instance profile for Router EC2"
}

variable "secret_arn" {
  type        = string
  description = "Secrets Manager ARN for storing AD admin password"
}

variable "cloudwatch_iam_instance_profile" {
  type        = string
  description = "IAM instance profile for CloudWatch Agent on Router EC2"
}


