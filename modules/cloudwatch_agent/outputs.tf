output "linux_ssm_param" {
  value = aws_ssm_parameter.cw_agent_linux.name
}

output "windows_ssm_param" {
  value = aws_ssm_parameter.cw_agent_windows.name
}

