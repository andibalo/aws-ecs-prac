terraform {
  backend "s3" {
    bucket = "tf-state-three-tier-staging"
    key    = "state/terraform.tfstate"
    encrypt = true
    region = "ap-southeast-1"
    profile = "andib"
  }
}