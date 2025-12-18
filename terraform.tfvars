aws_region    = "us-east-1"
key_name      = "my-key"
office_ip     = "37.201.118.108"
instance_type = "t3.micro"
domain_name   = "lab.local"


# AMI overrides
# router_ami = "ami-0ecb62995f68bb549"
# ad_ami     = "ami-0b4bc1e90f30ca1ec"
# jumpbox_ami= "ami-0ecb62995f68bb549"
# kali_ami   = "ami-0ecb62995f68bb549"

ad_secret_arn = "arn:aws:secretsmanager:us-east-1:021891606415:secret:lab-ad-admin-pass-Y9N4jr"

# MUST be instance profile names, not roles
ad_iam_instance_profile     = "AD-EC2-Role"
router_iam_instance_profile = "Router-EC2-Role"

cw_windows_document_name = "CWAgentInstall-Windows-2025-12-09T10-41-41Z"

# this line for CloudWatch dashboard
vpc_id = "vpc-0abcd1234ef567890"
