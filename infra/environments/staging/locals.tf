locals {
  tf_state_bucket_name = "tf-state-${var.app_name}-${var.environment}"
  db_name              = "${var.app_name}-${var.environment}-db"
  db_username          = "admin"
}