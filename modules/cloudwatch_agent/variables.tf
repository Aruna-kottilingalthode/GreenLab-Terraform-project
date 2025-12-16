variable "monitoring_tag_key" {
  type    = string
  default = "Monitoring"
}

variable "monitoring_tag_value" {
  type    = string
  default = "cloudwatch"
}

variable "ssm_param_name_linux" {
  type    = string
  default = "/cloudwatch/agent/config/linux"
}

variable "ssm_param_name_windows" {
  type    = string
  default = "/cloudwatch/agent/config/windows"
}

variable "ssm_association_interval" {
  type    = string
  default = "rate(30 minutes)" # SSM association re-run interval (valid rate expression)
}

variable "router_role_name" {
  type        = string
  description = "IAM role name for Router instance to attach CloudWatch permissions"
}

variable "jumpbox_instance_id" {
  type        = string
  description = "Instance ID of the Jumpbox"
}

variable "kali_instance_id" {
  type        = string
  description = "Instance ID of the Kali Linux server"
}

variable "ad_instance_id" {
  type        = string
  description = "Instance ID of the Active Directory server"
}

variable "router_instance_id" {
  type        = string
  description = "Router EC2 instance ID for CloudWatch monitoring"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for resources"
}

