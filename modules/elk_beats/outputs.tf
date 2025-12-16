output "winlogbeat_document_name" {
  description = "The SSM document name for Winlogbeat installation on Windows AD server"
  value       = aws_ssm_document.winlogbeat.name
}

output "winlogbeat_association_id" {
  description = "The SSM association ID for Winlogbeat"
  value       = aws_ssm_association.winlogbeat_assoc.id
}

output "linux_beats_document_name" {
  description = "The SSM document name for Filebeat/Metricbeat installation on Linux EC2s"
  value       = aws_ssm_document.filebeat_metricbeat.name
}

output "linux_beats_association_id" {
  description = "The SSM association ID for Linux EC2 beats installation"
  value       = aws_ssm_association.linux_beats_assoc.id
}

