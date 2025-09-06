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