provider "aws" {
  region                   = var.region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "andib"

  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}
