##############################
# CloudTrail S3 Bucket
##############################
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "greenlab-cloudtrail-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "greenlab-cloudtrail"
  }
}

# Versioning
resource "aws_s3_bucket_versioning" "cloudtrail_versioning" {
  bucket = aws_s3_bucket.cloudtrail.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_sse" {
  bucket = aws_s3_bucket.cloudtrail.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##############################
# IAM Role for CloudTrail
##############################
resource "aws_iam_role" "cloudtrail_role" {
  name = "greenlab-cloudtrail-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "cloudtrail.amazonaws.com" }
    }]
  })
}

# Inline policy for CloudWatch Logs
resource "aws_iam_role_policy" "cloudtrail_cwlogs" {
  name = "greenlab-cloudtrail-cwlogs"
  role = aws_iam_role.cloudtrail_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
      }
    ]
  })
}

# Optional managed policy
resource "aws_iam_role_policy_attachment" "cloudtrail_logs" {
  role       = aws_iam_role.cloudtrail_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

##############################
# CloudWatch Log Group
##############################
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/greenlab"
  retention_in_days = 365
}

##############################
# CloudWatch Metric Filters for Security
##############################

# Unauthorized API calls
resource "aws_cloudwatch_log_metric_filter" "unauthorized_access" {
  name           = "UnauthorizedAPICalls"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ $.errorCode = \"AccessDenied*\" }"

  metric_transformation {
    name      = "UnauthorizedAPICalls"
    namespace = "GreenLab/Security"
    value     = "1"
  }
}

# Failed console logins
resource "aws_cloudwatch_log_metric_filter" "console_login_failures" {
  name           = "FailedLogins"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ $.eventName = \"ConsoleLogin\" && $.errorMessage = \"Failed authentication\" }"

  metric_transformation {
    name      = "FailedLogins"
    namespace = "GreenLab/Security"
    value     = "1"
  }
}

##############################
# CloudTrail Resource
##############################
resource "aws_cloudtrail" "greenlab" {
  name                          = "greenlab-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = false
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn

  depends_on = [
    aws_cloudwatch_log_group.cloudtrail,
    aws_iam_role_policy.cloudtrail_cwlogs,
    aws_iam_role.cloudtrail_role,
    aws_iam_role_policy_attachment.cloudtrail_logs,
    aws_s3_bucket_policy.cloudtrail_policy
  ]
}

##############################
# S3 Bucket Policy for CloudTrail
##############################
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.cloudtrail.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck20150319"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = aws_s3_bucket.cloudtrail.arn
      },
      {
        Sid       = "AWSCloudTrailWrite20150319"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

