# Store CloudWatch Agent configs in SSM Parameter Store
resource "aws_ssm_parameter" "cw_agent_linux" {
  name      = var.ssm_param_name_linux
  type      = "String"
  value     = file("${path.module}/cloudwatch-agent-config-linux.json")
  overwrite = true
}

resource "aws_ssm_parameter" "cw_agent_windows" {
  name      = var.ssm_param_name_windows
  type      = "String"
  value     = file("${path.module}/cloudwatch-agent-config-windows.json")
  overwrite = true
}

##############################
# Linux SSM Document
##############################

resource "aws_ssm_document" "cw_linux_install" {
  name          = "CWAgentInstall-Linux-${replace(timestamp(), ":", "-")}"
  document_type = "Command"

  content = <<EOF
{
  "schemaVersion": "2.2",
  "description": "Install and configure CloudWatch Agent (Linux).",
  "parameters": {},
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "installAndConfigure",
      "inputs": {
        "runCommand": [
          "set -e",
          "yum -y install amazon-cloudwatch-agent || true",
          "apt-get update || true",
          "curl -sS -o /tmp/amazon-cloudwatch-agent.deb https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb || true",
          "if [ -f /tmp/amazon-cloudwatch-agent.deb ]; then dpkg -i /tmp/amazon-cloudwatch-agent.deb || true; fi",
          "amazon-cloudwatch-agent-ctl -a stop || true",
          "amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:${var.ssm_param_name_linux} || true",
          "amazon-cloudwatch-agent-ctl -a start || true"
        ]
      }
    }
  ]
}
EOF
}

##############################
# Windows SSM Document
##############################

resource "aws_ssm_document" "cw_windows_install" {
  name          = "CWAgentInstall-Windows-${replace(timestamp(), ":", "-")}"
  document_type = "Command"

  content = <<EOF
{
  "schemaVersion": "2.2",
  "description": "Install and configure CloudWatch Agent (Windows).",
  "parameters": {},
  "mainSteps": [
    {
      "action": "aws:runPowerShellScript",
      "name": "installAndConfigureWindows",
      "inputs": {
        "runCommand": [
          "Set-StrictMode -Version 1",
          "$zip = 'https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/AmazonCloudWatchAgent.zip'",
          "$dest = 'C:\\Temp\\AmazonCloudWatchAgent.zip'",
          "if (-not (Test-Path -Path 'C:\\Temp')) { New-Item -ItemType Directory -Path 'C:\\Temp' | Out-Null }",
          "Invoke-WebRequest -Uri $zip -OutFile $dest -UseBasicParsing -ErrorAction SilentlyContinue",
          "Expand-Archive -Path $dest -DestinationPath C:\\Temp\\AmazonCloudWatchAgent -Force",
          "Start-Process -FilePath msiexec.exe -ArgumentList '/i C:\\Temp\\AmazonCloudWatchAgent\\amazon-cloudwatch-agent.msi /qn' -Wait -NoNewWindow",
          "& 'C:\\Program Files\\Amazon\\AmazonCloudWatchAgent\\amazon-cloudwatch-agent-ctl.ps1' -a stop",
          "& 'C:\\Program Files\\Amazon\\AmazonCloudWatchAgent\\amazon-cloudwatch-agent-ctl.ps1' -a fetch-config -m ec2 -c ssm:${var.ssm_param_name_windows} -s",
          "& 'C:\\Program Files\\Amazon\\AmazonCloudWatchAgent\\amazon-cloudwatch-agent-ctl.ps1' -a status"
        ],
        "runtime": "powershell"
      }
    }
  ]
}  
EOF
}


##############################
# Associations
##############################

resource "aws_ssm_association" "cw_linux_assoc" {
  name = aws_ssm_document.cw_linux_install.name

  targets {
    key    = "tag:${var.monitoring_tag_key}"
    values = [var.monitoring_tag_value]
  }

  schedule_expression = var.ssm_association_interval
  compliance_severity = "CRITICAL"
  max_concurrency     = "2"
  max_errors          = "1"
}

resource "aws_ssm_association" "cw_windows_assoc" {
  name = aws_ssm_document.cw_windows_install.name

  targets {
    key    = "tag:${var.monitoring_tag_key}"
    values = [var.monitoring_tag_value]
  }

  schedule_expression = var.ssm_association_interval
  compliance_severity = "CRITICAL"
  max_concurrency     = "2"
  max_errors          = "1"
}

