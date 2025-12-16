##############################
# CPU Alarms
##############################

# Jumpbox CPU alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu_jumpbox" {
  alarm_name          = "Jumpbox-HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = module.jumpbox.jumpbox_instance_id
  }
}

# Router CPU alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu_router" {
  alarm_name          = "Router-HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = module.router.router_instance_id
  }
}

# Kali CPU alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu_kali" {
  alarm_name          = "Kali-HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = module.kali.kali_instance_id
  }
}

# AD CPU alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu_ad" {
  alarm_name          = "AD-HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = module.ad.ad_instance_id
  }
}

##############################
# Disk Used % Alarms
##############################

# Jumpbox Disk Used %
resource "aws_cloudwatch_metric_alarm" "disk_used_jumpbox" {
  alarm_name          = "Jumpbox-DiskUsedPercent"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DiskUsedPercent"
  namespace           = "GreenLab/Lab"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = module.jumpbox.jumpbox_instance_id
  }
}

# Router Disk Used %
resource "aws_cloudwatch_metric_alarm" "disk_used_router" {
  alarm_name          = "Router-DiskUsedPercent"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DiskUsedPercent"
  namespace           = "GreenLab/Lab"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = module.router.router_instance_id
  }
}

# Kali Disk Used %
resource "aws_cloudwatch_metric_alarm" "disk_used_kali" {
  alarm_name          = "Kali-DiskUsedPercent"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DiskUsedPercent"
  namespace           = "GreenLab/Lab"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = module.kali.kali_instance_id
  }
}

# AD Disk Used %
resource "aws_cloudwatch_metric_alarm" "disk_used_ad" {
  alarm_name          = "AD-DiskUsedPercent"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DiskUsedPercent"
  namespace           = "GreenLab/Lab"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = module.ad.ad_instance_id
  }
}

