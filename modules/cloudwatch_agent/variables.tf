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

