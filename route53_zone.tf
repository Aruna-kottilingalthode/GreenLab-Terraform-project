resource "aws_route53_zone" "greenlab" {
  name = "greenlab.local"

  vpc {
    vpc_id = aws_vpc.lab_vpc.id
  }

  comment = "GreenLab private DNS for jumpbox and lab infrastructure"
}

