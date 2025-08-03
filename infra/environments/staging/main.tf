# VPC
resource "aws_vpc" "two_tier_stg_vpc" {
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
  region                               = "ap-southeast-1"
  tags = {
    "Name" = "two-tier-vpc"
  }
  tags_all = {
    "Name" = "two-tier-vpc"
  }
}

# SUBNETS
resource "aws_subnet" "two_tier_stg_public_subnet_1a" {
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
  region                                         = "ap-southeast-1"
  tags = {
    "Name" = "two-tier-subnet-public1-ap-southeast-1a"
  }
  tags_all = {
    "Name" = "two-tier-subnet-public1-ap-southeast-1a"
  }
  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_subnet" "two_tier_stg_public_subnet_1b" {
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
  region                                         = "ap-southeast-1"
  tags = {
    "Name" = "two-tier-subnet-public1-ap-southeast-1b"
  }
  tags_all = {
    "Name" = "two-tier-subnet-public1-ap-southeast-1b"
  }
  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_subnet" "two_tier_stg_private_subnet_app_1a" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "ap-southeast-1a"
  cidr_block                                     = "12.0.128.0/20"
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
  region                                         = "ap-southeast-1"
  tags = {
    "Name" = "two-tier-subnet-private-app-ap-southeast-1a"
  }
  tags_all = {
    "Name" = "two-tier-subnet-private-app-ap-southeast-1a"
  }
  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_subnet" "two_tier_stg_private_subnet_db_1a" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "12.0.144.0/20"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"
  region                                         = "ap-southeast-1"
  tags = {
    Name = "two-tier-subnet-private-db-ap-southeast-1a"
  }

  tags_all = {
    Name = "two-tier-subnet-private-db-ap-southeast-1a"
  }

  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_subnet" "two_tier_stg_private_subnet_db_1b" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "12.0.160.0/20"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"
  region                                         = "ap-southeast-1"
  tags = {
    Name = "two-tier-subnet-private-db-ap-southeast-1b"
  }

  tags_all = {
    Name = "two-tier-subnet-private-db-ap-southeast-1b"
  }

  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

# SECURITY GROUPS
resource "aws_security_group" "two_tier_stg_default_sg" {
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

resource "aws_security_group" "two_tier_stg_alb_sg" {
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

resource "aws_security_group" "two_tier_stg_app_sg" {
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
    security_groups = ["${aws_security_group.two_tier_stg_open_vpn_sg.id}"]
    self            = "false"
    to_port         = "22"
  }

  ingress {
    from_port       = "3000"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.two_tier_stg_open_vpn_sg.id}"]
    self            = "false"
    to_port         = "3000"
  }

  ingress {
    from_port       = "443"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.two_tier_stg_alb_sg.id}"]
    self            = "false"
    to_port         = "443"
  }

  ingress {
    from_port       = "80"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.two_tier_stg_alb_sg.id}"]
    self            = "false"
    to_port         = "80"
  }

  ingress {
    from_port       = "8080"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.two_tier_stg_alb_sg.id}", "${aws_security_group.two_tier_stg_open_vpn_sg.id}"]
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

resource "aws_security_group" "two_tier_stg_open_vpn_sg" {
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

resource "aws_security_group" "two_tier_stg_rds_sg" {
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
    security_groups = ["${aws_security_group.two_tier_stg_app_sg.id}", "${aws_security_group.two_tier_stg_open_vpn_sg.id}", "${aws_security_group.two_tier_stg_ecs_sg.id}"]
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

resource "aws_security_group" "two_tier_stg_all_sg" {
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

resource "aws_security_group" "two_tier_stg_ecs_sg" {
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
    security_groups = ["${aws_security_group.two_tier_stg_alb_sg.id}"]
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

# INTERNET GATEWAY
resource "aws_internet_gateway" "two_tier_stg_igw" {
  region = "ap-southeast-1"
  tags = {
    "Name" = "two-tier-igw"
  }
  tags_all = {
    "Name" = "two-tier-igw"
  }
  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

# ROUTE TABLES
resource "aws_route_table" "two_tier_stg_default_rtb" {
  propagating_vgws = []
  region           = "ap-southeast-1"
  route            = []
  tags             = {}
  tags_all         = {}
  vpc_id           = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_route_table" "two_tier_stg_rtb_public" {
  propagating_vgws = []
  region           = "ap-southeast-1"
  route = [
    {
      carrier_gateway_id         = null
      cidr_block                 = "0.0.0.0/0"
      core_network_arn           = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      gateway_id                 = "igw-0b211e3e7afaf01e0"
      ipv6_cidr_block            = null
      local_gateway_id           = null
      nat_gateway_id             = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
    },
  ]
  tags = {
    "Name" = "two-tier-rtb-public"
  }
  tags_all = {
    "Name" = "two-tier-rtb-public"
  }
  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

resource "aws_route_table" "two_tier_stg_rtb_private" {
  propagating_vgws = []
  region           = "ap-southeast-1"
  route            = []
  tags = {
    "Name" = "two-tier-rtb-private1-ap-southeast-1a"
  }
  tags_all = {
    "Name" = "two-tier-rtb-private1-ap-southeast-1a"
  }
  vpc_id = "vpc-0d8eb46653bd7e4e9"
}

# ECS
resource "aws_ecs_cluster" "two_tier_stg_ecs_cluster" {
  name     = "TwoTierCluster"
  region   = "ap-southeast-1"
  tags     = {}
  tags_all = {}

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

# ECR
resource "aws_ecr_repository" "two_tier_stg_fe" {
  image_tag_mutability = "MUTABLE"
  name                 = "ecs-prac/fe"
  region               = "ap-southeast-1"
  tags                 = {}
  tags_all             = {}

  encryption_configuration {
    encryption_type = "AES256"
    kms_key         = null
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "two_tier_stg_be" {
  image_tag_mutability = "MUTABLE"
  name                 = "ecs-prac/be"
  region               = "ap-southeast-1"
  tags                 = {}
  tags_all             = {}

  encryption_configuration {
    encryption_type = "AES256"
    kms_key         = null
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}