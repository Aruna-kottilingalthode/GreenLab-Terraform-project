variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ad_instance_id" {
  type = string
}

variable "jumpbox_instance_id" {
  type = string
}

variable "jumpbox_private_ip" {
  type = string
}

variable "jumpbox_public_ip" {
  type = string
}

variable "kali_instance_id" {
  type = string
}

variable "router_instance_id" {
  type = string
}

variable "elk_host" {
  type        = string
  description = "ELK Docker host IP or DNS"
}

variable "elk_port" {
  type        = number
  default     = 5044
  description = "Beats input port on ELK"
}

variable "ssm_association_interval" {
  type    = string
  default = "rate(1 hour)"
}

variable "ssh_user" {
  description = "SSH user for reverse tunnel"
  type        = string
}

variable "jumpbox_dns" {
  description = "DNS name of Jumpbox"
  type        = string
}

