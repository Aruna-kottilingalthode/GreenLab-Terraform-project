resource "aws_instance" "ad" {
  ami                    = var.ad_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  user_data = templatefile("${path.module}/../../userdata/ad_userdata.tpl", {
    domain_name = var.domain_name
    SECRET_ARN  = var.secret_arn
    AWS_REGION  = var.aws_region
  })

  tags = {
    Name        = "AD-Server"
    Monitoring  = "cloudwatch"
    Environment = "lab"
  }
}


