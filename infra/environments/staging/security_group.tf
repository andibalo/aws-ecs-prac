

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