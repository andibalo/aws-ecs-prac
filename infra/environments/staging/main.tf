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

# ALB
resource "aws_lb" "alb" {
  client_keep_alive                                            = 3600
  customer_owned_ipv4_pool                                     = null
  desync_mitigation_mode                                       = "defensive"
  enable_cross_zone_load_balancing                             = true
  enable_http2                                                 = true
  enforce_security_group_inbound_rules_on_private_link_traffic = null
  idle_timeout                                                 = 60
  internal                                                     = false
  ip_address_type                                              = "ipv4"
  load_balancer_type                                           = "application"
  name                                                         = "${var.app_name}-${var.environment}-alb"
  security_groups = [
    aws_security_group.alb.id,
  ]
  subnets = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1b.id,
  ]
  tags = {
    Name = "${var.app_name}-${var.environment}-alb"
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

# ALB RULE
resource "aws_lb_listener" "http" {
  load_balancer_arn                    = aws_lb.alb.arn
  port                                 = 80
  protocol                             = "HTTP"
  routing_http_response_server_enabled = true
  ssl_policy                           = null
  tags = {
    Name = "${var.app_name}-${var.environment}-alb-listerner-http"
  }

  default_action {
    order            = 1
    target_group_arn = null
    type             = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  certificate_arn                      = aws_acm_certificate.dns_cert.arn
  load_balancer_arn                    = aws_lb.alb.arn
  port                                 = 443
  protocol                             = "HTTPS"
  routing_http_response_server_enabled = true
  ssl_policy                           = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  tags = {
    Name = "${var.app_name}-${var.environment}-alb-listener-https"
  }

  default_action {
    order            = 1
    target_group_arn = aws_lb_target_group.ecs_fe.arn
    type             = "forward"

    forward {
      stickiness {
        duration = 3600
        enabled  = false
      }
      target_group {
        arn    = aws_lb_target_group.ecs_fe.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener_rule" "route_to_api" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 1
  tags = {
    Name = "${var.app_name}-${var.environment}-alb-listener-rule-route-to-api"
  }

  action {
    order            = 1
    target_group_arn = aws_lb_target_group.ecs_be.arn
    type             = "forward"

    forward {
      stickiness {
        duration = 3600
        enabled  = false
      }
      target_group {
        arn    = aws_lb_target_group.ecs_be.arn
        weight = 1
      }
    }
  }

  condition {
    host_header {
      values = [
        "api.andisandbox.my.id",
      ]
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