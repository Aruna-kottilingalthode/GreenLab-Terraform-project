resource "aws_instance" "router" {
  ami                    = var.router_ami
  instance_type          = "t3.micro" # Or change if needed
  subnet_id              = var.subnet_id
  key_name               = "my-key" # replace with your key_name variable if needed
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.router_iam_instance_profile

  user_data = file("${path.module}/../../userdata/router_userdata.sh")

  tags = {
    Name        = "Router-Server"
    Monitoring  = "cloudwatch"
    Environment = "lab"

  }
}

