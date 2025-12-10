resource "aws_instance" "kali" {
  ami                    = var.kali_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.kali_iam_instance_profile

  tags = {
    Name        = "Kali-VM"
    Monitoring  = "cloudwatch"
    Environment = "lab"
  }
}

