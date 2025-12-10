output "ad_private_ip" {
  value = aws_instance.ad.private_ip
}

output "ad_instance_id" {
  value = aws_instance.ad.id
}
