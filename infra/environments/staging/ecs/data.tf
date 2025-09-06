data "aws_ecr_image" "latest_fe_image" {
  repository_name = "ecs-prac-stg/fe"
  most_recent     = true
}

data "aws_ecr_image" "latest_be_image" {
  repository_name = "ecs-prac-stg/be"
  most_recent     = true
}

data "terraform_remote_state" "main" {
  backend = "s3"

  config = {
    bucket = "tf-state-three-tier-staging"
    key    = "main/terraform.tfstate"
    region = "ap-southeast-1"
    shared_config_files      = ["~/.aws/config"]
    shared_credentials_files = ["~/.aws/credentials"]
    profile                  = "andib"
  }
}