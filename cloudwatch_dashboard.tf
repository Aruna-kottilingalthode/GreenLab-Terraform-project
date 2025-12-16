resource "aws_cloudwatch_dashboard" "greenlab" {
  dashboard_name = "GreenLab-Infra"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", module.jumpbox.jumpbox_instance_id],
            ["AWS/EC2", "CPUUtilization", "InstanceId", module.router.router_instance_id],
            ["AWS/EC2", "CPUUtilization", "InstanceId", module.kali.kali_instance_id],
            ["AWS/EC2", "CPUUtilization", "InstanceId", module.ad.ad_instance_id]
          ],
          view    = "timeSeries",
          stacked = false,
          region = var.aws_region,
          title   = "EC2 CPU Utilization"
        }
      }
    ]
  })
}

