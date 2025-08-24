data "local_file" "start_openvpn_sh" {
  filename = "${path.module}/start_openvpn.sh"
}

data "aws_ecr_image" "latest_fe_image" {
  repository_name = aws_ecr_repository.frontend.name
  most_recent     = true
}

data "aws_ecr_image" "latest_be_image" {
  repository_name = aws_ecr_repository.backend.name
  most_recent     = true
}