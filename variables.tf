variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type = string
}

variable "office_ip" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "router_ami" {
  type    = string
  default = "ami-0ecb62995f68bb549"
}

variable "ad_ami" {
  type    = string
  default = "ami-0b4bc1e90f30ca1ec"
}

variable "jumpbox_ami" {
  type        = string  
  default = "ami-0ecb62995f68bb549"
}

variable "kali_ami" {
  type    = string
  default = "ami-0ecb62995f68bb549"
}

variable "ad_secret_arn" {
  type        = string
  description = "Secrets Manager ARN for storing AD password"
}

variable "router_iam_instance_profile" {
  type        = string
}

variable "ad_iam_instance_profile" {
  type        = string
}

variable "domain_name" {
  type    = string
  default = "lab.local"
}

variable "cw_windows_document_name" {
  type        = string
  description = "Name of the imported CloudWatch Windows SSM Document"
}





