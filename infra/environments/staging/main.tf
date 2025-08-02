# VPC
resource "aws_vpc" "two-tier-stg-vpc" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = "12.0.0.0/16"
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  ipv6_association_id                  = null
  ipv6_cidr_block                      = null
  ipv6_cidr_block_network_border_group = null
  ipv6_ipam_pool_id                    = null
  tags = {
    "Name" = "two-tier-vpc"
  }
  tags_all = {
    "Name" = "two-tier-vpc"
  }
}

# SUBNETS
resource "aws_subnet" "two-tier-stg-public-subnet-1a" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "ap-southeast-1a"
  cidr_block                                     = "12.0.0.0/20"
  customer_owned_ipv4_pool                       = null
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_cidr_block                                = null
  ipv6_cidr_block_association_id                 = null
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  outpost_arn                                    = null
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    "Name" = "two-tier-subnet-public1-ap-southeast-1a"
  }
  tags_all = {
    "Name" = "two-tier-subnet-public1-ap-southeast-1a"
  }
  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_subnet" "two-tier-stg-public-subnet-1b" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "ap-southeast-1b"
  cidr_block                                     = "12.0.16.0/20"
  customer_owned_ipv4_pool                       = null
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_cidr_block                                = null
  ipv6_cidr_block_association_id                 = null
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  outpost_arn                                    = null
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    "Name" = "two-tier-subnet-public1-ap-southeast-1b"
  }
  tags_all = {
    "Name" = "two-tier-subnet-public1-ap-southeast-1b"
  }
  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_subnet" "two-tier-stg-private-subnet-app-1a" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "ap-southeast-1b"
  cidr_block                                     = "12.0.16.0/20"
  customer_owned_ipv4_pool                       = null
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_cidr_block                                = null
  ipv6_cidr_block_association_id                 = null
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  outpost_arn                                    = null
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    "Name" = "two-tier-subnet-public1-ap-southeast-1b"
  }
  tags_all = {
    "Name" = "two-tier-subnet-public1-ap-southeast-1b"
  }
  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_subnet" "two-tier-stg-private-subnet-db-1a" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "12.0.144.0/20"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "two-tier-subnet-private-db-ap-southeast-1a"
  }

  tags_all = {
    Name = "two-tier-subnet-private-db-ap-southeast-1a"
  }

  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_subnet" "tfer--subnet-0c014163ae851082f" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "12.0.160.0/20"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "two-tier-subnet-private-db-ap-southeast-1b"
  }

  tags_all = {
    Name = "two-tier-subnet-private-db-ap-southeast-1b"
  }

  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

# SECURITY GROUPS
resource "aws_security_group" "two-tier-stg-default_sg" {
  description = "default VPC security group"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port = "0"
    protocol  = "-1"
    self      = "true"
    to_port   = "0"
  }

  name   = "default"
  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_security_group" "two-tier-stg-alb-sg" {
  description = "two-tier-alb-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  name = "two-tier-alb-sg"

  tags = {
    Name = "two-tier-alb-sg"
  }

  tags_all = {
    Name = "two-tier-alb-sg"
  }

  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_security_group" "two-tier-stg-app-sg" {
  description = "two-tier-app-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port       = "22"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--two-tier-open-vpn-sg_sg-03027ad6831fe872c_id}"]
    self            = "false"
    to_port         = "22"
  }

  ingress {
    from_port       = "3000"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--two-tier-open-vpn-sg_sg-03027ad6831fe872c_id}"]
    self            = "false"
    to_port         = "3000"
  }

  ingress {
    from_port       = "443"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--two-tier-alb-sg_sg-05a744146806de11a_id}"]
    self            = "false"
    to_port         = "443"
  }

  ingress {
    from_port       = "80"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--two-tier-alb-sg_sg-05a744146806de11a_id}"]
    self            = "false"
    to_port         = "80"
  }

  ingress {
    from_port       = "8080"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--two-tier-alb-sg_sg-05a744146806de11a_id}", "${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--two-tier-open-vpn-sg_sg-03027ad6831fe872c_id}"]
    self            = "false"
    to_port         = "8080"
  }

  name = "two-tier-app-sg"

  tags = {
    Name = "two-tier-app-sg"
  }

  tags_all = {
    Name = "two-tier-app-sg"
  }

  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_security_group" "two-tier-stg-open-vpn-sg" {
  description = "open vpn sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "1194"
    protocol    = "udp"
    self        = "false"
    to_port     = "1194"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "943"
    protocol    = "tcp"
    self        = "false"
    to_port     = "943"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "945"
    protocol    = "tcp"
    self        = "false"
    to_port     = "945"
  }

  name = "two-tier-open-vpn-sg"

  tags = {
    Name = "two-tier-open-vpn-sg"
  }

  tags_all = {
    Name = "two-tier-open-vpn-sg"
  }

  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_security_group" "two-tier-stg-rds-sg" {
  description = "two-tier-rds-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port       = "3306"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--two-tier-app-sg_sg-0e57cb5562fb47408_id}", "${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--two-tier-open-vpn-sg_sg-03027ad6831fe872c_id}", "${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--twotier-ecs-sg_sg-03cde29bdaedd1bc1_id}"]
    self            = "false"
    to_port         = "3306"
  }

  name = "two-tier-rds-sg"

  tags = {
    Name = "two-tier-rds-sg"
  }

  tags_all = {
    Name = "two-tier-rds-sg"
  }

  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_security_group" "two-tier-stg-all-sg" {
  description = "twotier-all-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  name = "twotier-all-sg"

  tags = {
    Name = "twotier-all-sg"
  }

  tags_all = {
    Name = "twotier-all-sg"
  }

  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_security_group" "two-tier-stg-ecs-sg" {
  description = "twotier-ecs-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port       = "0"
    protocol        = "-1"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--two-tier-alb-sg_sg-05a744146806de11a_id}"]
    self            = "false"
    to_port         = "0"
  }

  name = "twotier-ecs-sg"

  tags = {
    Name = "twotier-ecs-sg"
  }

  tags_all = {
    Name = "twotier-ecs-sg"
  }

  vpc_id = "vpc-0d8eb46653bd7e4e9"
}
