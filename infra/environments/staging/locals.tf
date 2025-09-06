locals {
  tf_state_bucket_name = "tf-state-${var.app_name}-${var.environment}"
  db_name              = "three_tier_${var.environment}_db"
  db_username          = "admin"
}