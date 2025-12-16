output "router_private_ip" {
  description = "Router EC2 private IP"
  value       = aws_instance.router.private_ip
}

output "router_instance_id" {
  description = "Router EC2 instance ID"
  value       = aws_instance.router.id
}

