data "local_file" "start_openvpn_sh" {
  filename = "${path.module}/start_openvpn.sh"
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