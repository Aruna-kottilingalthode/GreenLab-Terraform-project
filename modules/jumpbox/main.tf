resource "aws_instance" "jumpbox" {
  ami                    = var.jumpbox_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.jumpbox_iam_instance_profile
  user_data = templatefile("${path.module}/../../userdata/jumpbox_userdata.tpl", {
    ad_domain  = var.ad_domain
    ad_realm   = var.ad_realm
    ad_dc_ip   = var.ad_private_ip
    secret_arn = var.secret_arn
    region     = var.region
  })

  tags = {
    Name        = "Jumpbox"
    Monitoring  = "cloudwatch"
    Environment = "lab"

  }
}


