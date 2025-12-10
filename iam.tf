# iam.tf
# IAM Role and Instance Profile for AD Server
resource "aws_iam_role" "ad_role" {
  name = "ADRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ad_cloudwatch_attach" {
  role       = aws_iam_role.ad_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}

resource "aws_iam_instance_profile" "ad_instance_profile" {
  name = "ADProfile"
  role = aws_iam_role.ad_role.name
}

# IAM Role and Instance Profile for Router Server
resource "aws_iam_role" "router_role" {
  name = "RouterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "router_policy_attach" {
  role       = aws_iam_role.router_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "router_instance_profile" {
  name = "RouterProfile"
  role = aws_iam_role.router_role.name
}

# CloudWatch IAM Role for EC2 Instances
resource "aws_iam_role" "cloudwatch_agent_role" {
  name = "CloudWatchAgentRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# CloudWatch IAM Policy from JSON
resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name   = "CloudWatchAgentPolicy"
  policy = file("${path.module}/cloudwatch-agent-policy.json")
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "cw_policy_attach" {
  role       = aws_iam_role.cloudwatch_agent_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}

# Instance Profile for EC2 to use CloudWatch
resource "aws_iam_instance_profile" "cloudwatch_instance_profile" {
  name = "CloudWatchAgentProfile"
  role = aws_iam_role.cloudwatch_agent_role.name
}

################################################################################
# ✅ FIX — Combined IAM ROLE for AD Server (SSM + CloudWatch)
################################################################################

resource "aws_iam_role" "ad_combined_role" {
  name = "ADCombinedRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach SSM Core policy
resource "aws_iam_role_policy_attachment" "ad_combined_ssm" {
  role       = aws_iam_role.ad_combined_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach CloudWatch policy
resource "aws_iam_role_policy_attachment" "ad_combined_cloudwatch" {
  role       = aws_iam_role.ad_combined_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}

# Instance Profile for AD server
resource "aws_iam_instance_profile" "ad_combined_profile" {
  name = "ADCombinedProfile"
  role = aws_iam_role.ad_combined_role.name
}

