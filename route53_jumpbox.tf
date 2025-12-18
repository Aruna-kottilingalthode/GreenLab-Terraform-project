resource "aws_route53_record" "jumpbox" {
  zone_id = aws_route53_zone.greenlab.zone_id
  name    = "jumpbox.greenlab.local"
  type    = "A"
  ttl     = 30

  records = [module.jumpbox.jumpbox_private_ip]
}

resource "aws_route53_record" "ad_record" {
  zone_id = aws_route53_zone.greenlab.zone_id  # reference your private zone resource
  name    = "ad.greenlab.local"
  type    = "A"
  ttl     = 30
  records = [module.ad.ad_private_ip]             
}

