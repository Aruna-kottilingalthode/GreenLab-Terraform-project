output "kali_private_ip" {
  description = "Kali EC2 private IP"
  value       = aws_instance.kali.private_ip
}

output "kali_instance_id" {
  value = aws_instance.kali.id
}


