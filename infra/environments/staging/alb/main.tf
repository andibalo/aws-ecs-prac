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
    data.terraform_remote_state.main.outputs.alb_sg_id,
  ]
  subnets = [
    data.terraform_remote_state.main.outputs.public_subnet_1a_id,
    data.terraform_remote_state.main.outputs.public_subnet_1b_id,
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
  vpc_id      = data.terraform_remote_state.main.outputs.vpc_id

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
  vpc_id      = data.terraform_remote_state.main.outputs.vpc_id

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
  certificate_arn                      = data.terraform_remote_state.main.outputs.dns_cert_arn
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