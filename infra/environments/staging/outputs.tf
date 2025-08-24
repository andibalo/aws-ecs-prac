output "aws_security_group--alb_sg" {
  value = aws_security_group.alb.id
}

output "aws_security_group--app_sg" {
  value = aws_security_group.app.id
}

output "aws_security_group--open_vpn_sg" {
  value = aws_security_group.open_vpn.id
}

output "aws_security_group--rds_sg" {
  value = aws_security_group.rds.id
}

output "aws_security_group--all_sg" {
  value = aws_security_group.all.id
}

output "aws_security_group--ecs_sg" {
  value = aws_security_group.ecs.id
}

output "aws_ecr_image--latest_fe_image_uri" {
  value = data.aws_ecr_image.latest_fe_image.image_uri
}

output "aws_ecr_image--latest_be_image_uri" {
  value = data.aws_ecr_image.latest_be_image.image_uri
}
