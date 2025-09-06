terraform {
  backend "s3" {
    bucket                   = "tf-state-three-tier-staging"
    key                      = "rds/terraform.tfstate"
    encrypt                  = true
    region                   = "ap-southeast-1"
    use_lockfile             = true
    shared_config_files      = ["~/.aws/config"]
    shared_credentials_files = ["~/.aws/credentials"]
    profile                  = "andib"
  }
}