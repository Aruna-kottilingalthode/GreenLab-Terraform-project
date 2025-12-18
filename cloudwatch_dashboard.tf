resource "aws_cloudwatch_dashboard" "greenlab" {
  dashboard_name = "GreenLab-Infra"

  dashboard_body = jsonencode({
    widgets = [
      ##############################
      # EC2 CPU Utilization
      ##############################
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
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "EC2 CPU Utilization"
        }
      },

      ##############################
      # EC2 Disk Usage
      ##############################
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["GreenLab/Lab", "DiskUsedPercent", "InstanceId", module.jumpbox.jumpbox_instance_id],
            ["GreenLab/Lab", "DiskUsedPercent", "InstanceId", module.router.router_instance_id],
            ["GreenLab/Lab", "DiskUsedPercent", "InstanceId", module.kali.kali_instance_id],
            ["GreenLab/Lab", "DiskUsedPercent", "InstanceId", module.ad.ad_instance_id]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "EC2 Disk Usage"
        }
      },

      ##############################
      # Unauthorized API Calls
      ##############################
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["GreenLab/Security", "UnauthorizedAPICalls"]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Unauthorized API Calls"
        }
      },

      ##############################
      # Failed Console Logins
      ##############################
      {
        type   = "metric"
        x      = 0
        y      = 18
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["GreenLab/Security", "FailedLogins"]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Failed Console Logins"
        }
      },

      ##############################
      # S3 Bucket Activity (All Buckets)
      ##############################
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/S3", "NumberOfObjects", "BucketName", aws_s3_bucket.cloudtrail.bucket, "StorageType", "AllStorageTypes"],
            ["AWS/S3", "AllRequests", "BucketName", aws_s3_bucket.cloudtrail.bucket]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "S3 Bucket Activity"
        }
      },

      ##############################
      # VPC Network Traffic
      ##############################
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/VPC", "NetworkPacketsIn", "VpcId", var.vpc_id],
            ["AWS/VPC", "NetworkPacketsOut", "VpcId", var.vpc_id]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "VPC Network Traffic"
        }
      }
    ]
  })
}

