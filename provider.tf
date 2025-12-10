terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # template provider removed completely
  }
}

provider "aws" {
  region = var.aws_region
}





