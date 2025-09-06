# RDS
resource "random_password" "db_master_password" {
  length           = 16
  special          = true
  override_special = "!#$&*()-=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "dsn" {
  name                    = "${var.app_name}-${var.environment}-dsn-secret"
  recovery_window_in_days = 0
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
  db_subnet_group_name = aws_db_subnet_group.default.name
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.private_db_1a.id, aws_subnet.private_db_1b.id]

  tags = {
    Name = "${var.app_name}-${var.environment}-db-subnet-group"
  }
}