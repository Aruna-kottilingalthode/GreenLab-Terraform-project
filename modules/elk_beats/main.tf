##############################
# Linux Beats (Filebeat/Metricbeat)
##############################
resource "aws_ssm_document" "filebeat_metricbeat" {
  name          = "Filebeat-Metricbeat-Install-${replace(timestamp(), ":", "-")}"
  document_type = "Command"

  content = <<EOF
{
  "schemaVersion": "2.2",
  "description": "Install Filebeat and Metricbeat on Linux EC2s",
  "parameters": {},
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "installBeats",
      "inputs": {
        "runCommand": [
          "set -e",
          "curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.10.0-amd64.deb",
          "dpkg -i filebeat-8.10.0-amd64.deb",
          "curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.10.0-amd64.deb",
          "dpkg -i metricbeat-8.10.0-amd64.deb",
          "filebeat modules enable system",
          "metricbeat modules enable system",
          "sed -i 's|output.elasticsearch:.*|output.elasticsearch:\\n  hosts: [\"localhost:5044\"]|' /etc/filebeat/filebeat.yml",
          "sed -i 's|output.elasticsearch:.*|output.elasticsearch:\\n  hosts: [\"localhost:5044\"]|' /etc/metricbeat/metricbeat.yml",

          "systemctl enable filebeat && systemctl restart filebeat",
          "systemctl enable metricbeat && systemctl restart metricbeat"
        ]
      }
    }
  ]
}
EOF
}

resource "aws_ssm_association" "linux_beats_assoc" {
  name = aws_ssm_document.filebeat_metricbeat.name

  targets {
    key = "InstanceIds"
    values = [
      var.jumpbox_instance_id,
      var.kali_instance_id,
      var.router_instance_id
    ]
  }

  schedule_expression = var.ssm_association_interval
  compliance_severity = "CRITICAL"
  max_concurrency     = "2"
  max_errors          = "1"
}

##############################
# Windows Beats (Winlogbeat)
##############################
resource "aws_ssm_document" "winlogbeat" {
  name          = "Winlogbeat-Install-${replace(timestamp(), ":", "-")}"
  document_type = "Command"

  content = <<EOF
{
  "schemaVersion": "2.2",
  "description": "Install Winlogbeat on Windows AD Server",
  "parameters": {},
  "mainSteps": [
    {
      "action": "aws:runPowerShellScript",
      "name": "installWinlogbeat",
      "inputs": {
        "runCommand": [
          "Invoke-WebRequest -Uri https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.10.0-windows-x86_64.zip -OutFile C:\\Temp\\winlogbeat.zip",
          "Expand-Archive -Path C:\\Temp\\winlogbeat.zip -DestinationPath C:\\Program Files\\Winlogbeat -Force",
          "Set-ExecutionPolicy Unrestricted -Force",
          "C:\\Program Files\\Winlogbeat\\winlogbeat.exe install",
          "& 'C:\\Program Files\\Winlogbeat\\winlogbeat.exe' -c C:\\Program Files\\Winlogbeat\\winlogbeat.yml -e"
        ],
        "runtime": "powershell"
      }
    }
  ]
}
EOF
}

resource "aws_ssm_association" "winlogbeat_assoc" {
  name = aws_ssm_document.winlogbeat.name

  targets {
    key = "InstanceIds"
    values = [
      var.ad_instance_id
    ]
  }

  schedule_expression = var.ssm_association_interval
  compliance_severity = "CRITICAL"
  max_concurrency     = "1"
  max_errors          = "1"
}

