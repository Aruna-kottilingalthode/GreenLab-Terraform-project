# VPC
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "lab-vpc" }
}

# Subnets
resource "aws_subnet" "lab_public_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "lab-igw"
  }
}
resource "aws_route_table" "lab_public_rt" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }

  tags = {
    Name = "lab-public-rt"
  }
}

resource "aws_route_table_association" "lab_public_assoc" {
  subnet_id      = aws_subnet.lab_public_subnet.id
  route_table_id = aws_route_table.lab_public_rt.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_gw_eip" {
  domain = "vpc"
  tags = {
    Name = "lab-nat-eip"
  }
}

# NAT Gateway in public subnet
resource "aws_nat_gateway" "lab_nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.lab_public_subnet.id
  tags = {
    Name = "lab-nat-gateway"
  }
}

# Route table for private subnet to use NAT
resource "aws_route_table" "lab_private_rt" {
  vpc_id = aws_vpc.lab_vpc.id
  tags = {
    Name = "lab-private-rt"
  }
}

# Default route via NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.lab_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.lab_nat_gw.id
}

# Associate private subnet with its route table
resource "aws_route_table_association" "private_subnet_assoc" {
  subnet_id      = aws_subnet.lab_private_subnet.id
  route_table_id = aws_route_table.lab_private_rt.id
}


resource "aws_subnet" "lab_private_subnet" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "us-east-1a"
}

# Security Groups
resource "aws_security_group" "ad_sg" {
  name        = "ad-sg"
  description = "Security group for AD server"
  vpc_id      = aws_vpc.lab_vpc.id

  # Allow ALL traffic from the Jumpbox SG  
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.jumpbox_sg.id]
    description     = "Allow all traffic from Jumpbox"
  }

  # Allow traffic from inside VPC (optional but recommended for other private hosts)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Internal VPC communication"
  }

  # Outbound allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # DNS
  ingress {
    from_port       = 53
    to_port         = 53
    protocol        = "udp"
    security_groups = [aws_security_group.jumpbox_sg.id]
    description     = "DNS UDP from Jumpbox"
  }

  ingress {
    from_port       = 53
    to_port         = 53
    protocol        = "tcp"
    security_groups = [aws_security_group.jumpbox_sg.id]
    description     = "DNS TCP from Jumpbox"
  }

  # LDAP
  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "LDAP"
  }

  # SMB
  ingress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "SMB"
  }

  # Kerberos
  ingress {
    from_port   = 88
    to_port     = 88
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Kerberos TCP"
  }

  ingress {
    from_port   = 88
    to_port     = 88
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Kerberos UDP"
  }

  # RPC
  ingress {
    from_port   = 135
    to_port     = 135
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "RPC"
  }

  # Global Catalog
  ingress {
    from_port   = 3268
    to_port     = 3268
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Global Catalog"
  }

  # SSH for Jumpbox
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow Jumpbox SSH"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jumpbox_sg" {
  name   = "jumpbox-sg"
  vpc_id = aws_vpc.lab_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.office_ip}/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lab_internal_sg" {
  name        = "lab-internal-sg"
  description = "Internal traffic"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Modules

module "router" {
  source                          = "./modules/router"
  instance_type                   = var.instance_type
  router_ami                      = var.router_ami
  key_name                        = var.key_name
  user_data                       = ""
  subnet_id                       = aws_subnet.lab_private_subnet.id
  security_group_ids              = [aws_security_group.lab_internal_sg.id]
  router_iam_instance_profile     = aws_iam_instance_profile.router_instance_profile.name
  cloudwatch_iam_instance_profile = aws_iam_instance_profile.cloudwatch_instance_profile.name
  secret_arn                      = var.ad_secret_arn
}

module "ad" {
  source             = "./modules/ad"
  instance_type      = var.instance_type
  ad_ami             = var.ad_ami
  key_name           = var.key_name
  subnet_id          = aws_subnet.lab_private_subnet.id
  security_group_ids = [aws_security_group.ad_sg.id]
  domain_name        = var.domain_name
  user_data = templatefile("${path.root}/userdata/ad_userdata.tpl", {
    domain_name = var.domain_name
    SECRET_ARN  = var.ad_secret_arn
    AWS_REGION  = var.aws_region
  })
  iam_instance_profile     = aws_iam_instance_profile.ad_combined_profile.name
  secret_arn               = var.ad_secret_arn
  aws_region               = var.aws_region
  cw_windows_document_name = "CWAgentInstall-Windows-2025-12-09T10-41-41Z"
}

resource "aws_ssm_association" "cw_windows_ad" {
  name = var.cw_windows_document_name

  targets {
    key    = "InstanceIds"
    values = [module.ad.ad_instance_id]
  }
}

module "kali" {
  source                    = "./modules/kali"
  instance_type             = var.instance_type
  kali_ami                  = var.kali_ami
  key_name                  = var.key_name
  subnet_id                 = aws_subnet.lab_private_subnet.id
  security_group_ids        = [aws_security_group.lab_internal_sg.id]
  kali_iam_instance_profile = aws_iam_instance_profile.cloudwatch_instance_profile.name
}

module "jumpbox" {
  source                       = "./modules/jumpbox"
  instance_type                = var.instance_type
  jumpbox_ami                  = var.jumpbox_ami
  key_name                     = var.key_name
  subnet_id                    = aws_subnet.lab_public_subnet.id
  security_group_ids           = [aws_security_group.jumpbox_sg.id]
  jumpbox_iam_instance_profile = aws_iam_instance_profile.cloudwatch_instance_profile.name
  ad_private_ip                = module.ad.ad_private_ip

  ad_domain  = var.domain_name
  ad_realm   = upper(var.domain_name)
  secret_arn = var.ad_secret_arn
  region     = var.aws_region

  user_data = templatefile("${path.root}/userdata/jumpbox_userdata.tpl", {
    ad_dc_ip   = module.ad.ad_private_ip # AD server private IP
    ad_domain  = var.domain_name         # AD domain, e.g., lab.local
    ad_realm   = upper(var.domain_name)  # AD realm, e.g., LAB.LOCAL
    secret_arn = var.ad_secret_arn       # ARN of AD admin password secret
    region     = var.aws_region

  })
}

module "cloudwatch_agent" {
  source = "./modules/cloudwatch_agent"

  monitoring_tag_key   = "Monitoring"
  monitoring_tag_value = "cloudwatch"
  jumpbox_instance_id  = module.jumpbox.jumpbox_instance_id
  router_instance_id   = module.router.router_instance_id
  kali_instance_id     = module.kali.kali_instance_id
  ad_instance_id       = module.ad.ad_instance_id
  region               = var.aws_region

  # optional: use these if you changed defaults
  # ssm_param_name_linux = "/cloudwatch/agent/config/linux"
  # ssm_param_name_windows = "/cloudwatch/agent/config/windows"
  # ssm_association_interval = "rate(30 minutes)"
  router_role_name = aws_iam_role.router_role.name
}

resource "aws_ssm_document" "cw_windows_install" {
  name          = "CWAgentInstall-Windows-2025-12-09T10-41-41Z"
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
          "& 'C:\\Program Files\\Amazon\\AmazonCloudWatchAgent\\amazon-cloudwatch-agent-ctl.ps1' -a status"
        ]
      }
    }
  ]
}
EOF
}

module "elk_beats" {
  source = "./modules/elk_beats"

  project             = "greenlab"
  region              = var.aws_region
  ad_instance_id      = module.ad.ad_instance_id
  jumpbox_instance_id = module.jumpbox.jumpbox_instance_id
  jumpbox_private_ip  = module.jumpbox.jumpbox_private_ip
  jumpbox_public_ip   = module.jumpbox.jumpbox_public_ip
  kali_instance_id    = module.kali.kali_instance_id
  router_instance_id  = module.router.router_instance_id
  elk_host            = "172.18.0.2"
  elk_port            = 5044
  ssh_user            = "ubuntu" # (match AMI)
  jumpbox_dns         = aws_route53_record.jumpbox.fqdn

}

