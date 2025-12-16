output "router_private_ip" {
  value = module.router.router_private_ip
}

output "ad_private_ip" {
  value = module.ad.ad_private_ip
}

output "kali_private_ip" {
  value = module.kali.kali_private_ip
}

output "jumpbox_public_ip" {
  value = module.jumpbox.jumpbox_public_ip
}

output "jumpbox_dns" {
  value = aws_route53_record.jumpbox.fqdn
}

