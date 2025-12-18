# CPU High Alarm (75%)
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "GreenLab-CPU-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "GreenLab/Lab"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Alarm if CPU > 75%"
  dimensions = {
    InstanceId = module.router.router_instance_id
  }
  alarm_actions = [] # Add SNS ARN if needed
}

# Memory High Alarm (80%)
resource "aws_cloudwatch_metric_alarm" "mem_high" {
  alarm_name          = "GreenLab-Memory-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "GreenLab/Lab"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm if Memory > 80%"
  dimensions = {
    InstanceId = module.router.router_instance_id
  }
  alarm_actions = []
}

# Disk Usage High Alarm (90%)
resource "aws_cloudwatch_metric_alarm" "disk_high" {
  alarm_name          = "GreenLab-Disk-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "disk_used_percent"
  namespace           = "GreenLab/Lab"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "Alarm if Disk Usage > 90%"
  dimensions = {
    InstanceId = module.router.router_instance_id
  }
  alarm_actions = []
}

