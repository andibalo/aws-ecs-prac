# VPC
resource "aws_vpc" "vpc" {
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
    "Name" = "${var.app_name}-${var.environment}-vpc"
  }
}

# SUBNETS
resource "aws_subnet" "public_1a" {
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
    "Name" = "${var.app_name}-${var.environment}-subnet-public-1a"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public_1b" {
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
    "Name" = "${var.app_name}-${var.environment}-subnet-public-1b"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "private_app_1a" {
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
  tags = {
    "Name" = "${var.app_name}-${var.environment}-subnet-private-app-1a"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "private_db_1a" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "12.0.144.0/20"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "${var.app_name}-${var.environment}-subnet-private-db-1a"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "private_db_1b" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "12.0.160.0/20"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "${var.app_name}-${var.environment}-subnet-private-db-1b"
  }
  vpc_id = aws_vpc.vpc.id
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  tags = {
    "Name" = "${var.app_name}-${var.environment}-igw"
  }
  vpc_id = aws_vpc.vpc.id
}

# ROUTE TABLES
resource "aws_route_table" "public" {
  propagating_vgws = []
  route = [
    {
      carrier_gateway_id         = null
      cidr_block                 = "0.0.0.0/0"
      core_network_arn           = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      gateway_id                 = aws_internet_gateway.igw.id
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
    "Name" = "${var.app_name}-${var.environment}-rtb-public"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "private" {
  propagating_vgws = []
  route            = []
  tags = {
    "Name" = "${var.app_name}-${var.environment}-rtb-private"

  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "public_1a_subnet_association" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1b_subnet_association" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app_1a_subnet_association" {
  subnet_id      = aws_subnet.private_app_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_1a_subnet_association" {
  subnet_id      = aws_subnet.private_db_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_1b_subnet_association" {
  subnet_id      = aws_subnet.private_db_1b.id
  route_table_id = aws_route_table.private.id
}
