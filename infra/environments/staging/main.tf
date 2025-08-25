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

# SECURITY GROUPS
resource "aws_security_group" "alb" {
  description = "${var.app_name}-${var.environment}-alb-sg"

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

  name = "${var.app_name}-${var.environment}-alb-sg"

  tags = {
    Name = "${var.app_name}-${var.environment}-alb-sg"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group" "app" {
  description = "${var.app_name}-${var.environment}-app-sg"

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
    security_groups = ["${aws_security_group.open_vpn.id}"]
    self            = "false"
    to_port         = "22"
  }

  ingress {
    from_port       = "3000"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.open_vpn.id}"]
    self            = "false"
    to_port         = "3000"
  }

  ingress {
    from_port       = "443"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb.id}"]
    self            = "false"
    to_port         = "443"
  }

  ingress {
    from_port       = "80"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb.id}"]
    self            = "false"
    to_port         = "80"
  }

  ingress {
    from_port       = "8080"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb.id}", "${aws_security_group.open_vpn.id}"]
    self            = "false"
    to_port         = "8080"
  }

  name = "${var.app_name}-${var.environment}-app-sg"

  tags = {
    Name = "${var.app_name}-${var.environment}-app-sg"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group" "open_vpn" {
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

  name = "${var.app_name}-${var.environment}-open-vpn-sg"

  tags = {
    Name = "${var.app_name}-${var.environment}-open-vpn-sg"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group" "rds" {
  description = "${var.app_name}-${var.environment}-rds-sg"

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
    security_groups = ["${aws_security_group.app.id}", "${aws_security_group.open_vpn.id}", "${aws_security_group.ecs.id}"]
    self            = "false"
    to_port         = "3306"
  }

  name = "${var.app_name}-${var.environment}-rds-sg"

  tags = {
    Name = "${var.app_name}-${var.environment}-rds-sg"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group" "all" {
  description = "${var.app_name}-${var.environment}-all-sg"

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

  name = "${var.app_name}-${var.environment}-all-sg"

  tags = {
    Name = "${var.app_name}-${var.environment}-all-sg"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group" "ecs" {
  description = "${var.app_name}-${var.environment}-ecs-sg"

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
    security_groups = ["${aws_security_group.alb.id}"]
    self            = "false"
    to_port         = "0"
  }

  name = "${var.app_name}-${var.environment}-ecs-sg"

  tags = {
    Name = "${var.app_name}-${var.environment}-ecs-sg"
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

# ECS
resource "aws_ecs_cluster" "ecs" {
  name = "${var.app_name}-${var.environment}"
  tags = {
    Name = "${var.app_name}-${var.environment}-ecs-cluster"
  }

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

# ECR
resource "aws_ecr_repository" "frontend" {
  image_tag_mutability = "MUTABLE"
  name                 = var.frontend_ecr_name
  tags = {
    Name = "${var.app_name}-${var.environment}-ecr-fe"
  }

  encryption_configuration {
    encryption_type = "AES256"
    kms_key         = null
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "backend" {
  image_tag_mutability = "MUTABLE"
  name                 = var.backend_ecr_name
  tags = {
    Name = "${var.app_name}-${var.environment}-ecr-be"
  }

  encryption_configuration {
    encryption_type = "AES256"
    kms_key         = null
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}

# ACM
resource "aws_acm_certificate" "dns_cert" {
  certificate_authority_arn = null
  domain_name               = "andisandbox.my.id"
  early_renewal_duration    = null
  key_algorithm             = "RSA_2048"
  subject_alternative_names = [
    "*.andisandbox.my.id",
    "andisandbox.my.id",
  ]
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "ENABLED"
    export                                      = "DISABLED"
  }
}

# TARGET GROUPS
resource "aws_lb_target_group" "ecs_be" {
  deregistration_delay              = "300"
  ip_address_type                   = "ipv4"
  load_balancing_algorithm_type     = "round_robin"
  load_balancing_anomaly_mitigation = "off"
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"
  name                              = "${var.app_name}-${var.environment}-ecs-be-tg"
  name_prefix                       = null
  port                              = 8080
  protocol                          = "HTTP"
  protocol_version                  = "HTTP1"
  slow_start                        = 0
  tags = {
    Name = "${var.app_name}-${var.environment}-ecs-be-tg"
  }
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/users"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  stickiness {
    cookie_duration = 86400
    cookie_name     = null
    enabled         = false
    type            = "lb_cookie"
  }

  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count      = 1
      minimum_healthy_targets_percentage = "off"
    }
  }
}

resource "aws_lb_target_group" "ecs_fe" {
  deregistration_delay              = "300"
  ip_address_type                   = "ipv4"
  load_balancing_algorithm_type     = "round_robin"
  load_balancing_anomaly_mitigation = "off"
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"
  name                              = "${var.app_name}-${var.environment}-ecs-fe-tg"
  name_prefix                       = null
  port                              = 80
  protocol                          = "HTTP"
  protocol_version                  = "HTTP1"
  slow_start                        = 0
  tags = {
    Name = "${var.app_name}-${var.environment}-ecs-fe-tg"
  }
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  stickiness {
    cookie_duration = 86400
    cookie_name     = null
    enabled         = false
    type            = "lb_cookie"
  }

  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }
    unhealthy_state_routing {
      minimum_healthy_targets_count      = 1
      minimum_healthy_targets_percentage = "off"
    }
  }
}

# EC2
resource "aws_instance" "open_vpn" {
  ami                                  = "ami-0933f1385008d33c4"
  associate_public_ip_address          = true
  availability_zone                    = "ap-southeast-1a"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = true
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3.micro"
  key_name                             = var.ec2_key_name
  source_dest_check                    = true
  spot_instance_request_id             = null
  subnet_id                            = aws_subnet.public_1a.id

  user_data = data.local_file.start_openvpn_sh.content
  tags = {
    "Name" = "open-vpn"
  }
  tenancy = "default"
  vpc_security_group_ids = [
    aws_security_group.open_vpn.id,
  ]

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    amd_sev_snp      = null
    core_count       = 1
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  enclave_options {
    enabled = false
  }

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record    = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null
    tags                  = {}
    tags_all              = {}
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}

# S3
resource "aws_s3_bucket" "tf_state" {
  bucket = local.tf_state_bucket_name
  tags = {
    Name = "${var.app_name}-${var.environment}-tf-state-bucket"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# RDS
resource "random_password" "db_master_password" {
  length = 16
}

resource "aws_secretsmanager_secret" "dsn" {
  name = "${var.app_name}-${var.environment}-dsn"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.dsn.id
  secret_string = "${local.db_username}:${random_password.db_master_password.result}@tcp(${aws_db_instance.db.endpoint}:3306)/${aws_db_instance.db.db_name}"
}

resource "aws_db_instance" "db" {
  allocated_storage                     = 20
  auto_minor_version_upgrade            = true
  availability_zone                     = "ap-southeast-1b"
  backup_retention_period               = 1
  backup_target                         = "region"
  backup_window                         = "20:32-21:02"
  ca_cert_identifier                    = "rds-ca-rsa2048-g1"
  copy_tags_to_snapshot                 = true
  database_insights_mode                = "standard"
  db_name                               = local.db_name
  delete_automated_backups              = true
  engine                                = "mysql"
  engine_lifecycle_support              = "open-source-rds-extended-support-disabled"
  engine_version                        = "8.0.42"
  iam_database_authentication_enabled   = false
  identifier                            = "three-tier-staging"
  instance_class                        = "db.t4g.micro"
  iops                                  = 0
  license_model                         = "general-public-license"
  maintenance_window                    = "fri:18:11-fri:18:41"
  max_allocated_storage                 = 1000
  monitoring_interval                   = 0
  monitoring_role_arn                   = null
  multi_az                              = false
  nchar_character_set_name              = null
  network_type                          = "IPV4"
  option_group_name                     = "default:mysql-8-0"
  parameter_group_name                  = "default.mysql8.0"
  performance_insights_enabled          = false
  performance_insights_kms_key_id       = null
  performance_insights_retention_period = 0
  port                                  = 3306
  publicly_accessible                   = false
  replica_mode                          = null
  replicate_source_db                   = null
  skip_final_snapshot                   = true
  storage_encrypted                     = true
  storage_throughput                    = 0
  storage_type                          = "gp2"
  username                              = local.db_username
  password                              = random_password.db_master_password.result
  tags = {
    Name = "${var.app_name}-${var.environment}-db"
  }
  vpc_security_group_ids = [
    aws_security_group.rds.id,
  ]
}