#########################
# VPC Flow Logs IAM Role
#########################
resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "greenlab-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "greenlab-vpc-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

#########################
# CloudWatch Log Group for VPC Flow Logs
#########################
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/GreenLab/VPCFlowLogs"
  retention_in_days = 90
  tags = {
    Name = "GreenLab VPC Flow Logs"
  }
}

#########################
# VPC Flow Log
#########################
resource "aws_flow_log" "vpc_flow_log" {
  log_destination          = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type     = "cloud-watch-logs"
  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.lab_vpc.id
  iam_role_arn             = aws_iam_role.vpc_flow_logs_role.arn
  max_aggregation_interval = 60 # Optional: capture logs every 60 seconds

  tags = {
    Name = "GreenLab-VPCFlowLog"
  }
}

