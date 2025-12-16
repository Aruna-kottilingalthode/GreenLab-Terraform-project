output "jumpbox_private_ip" {
  value = aws_instance.jumpbox.private_ip
}

output "jumpbox_public_ip" {
  value = aws_instance.jumpbox.public_ip
}

output "jumpbox_instance_id" {
  value = aws_instance.jumpbox.id
}

