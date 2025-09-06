output "dns_cert_arn" {
  value = aws_acm_certificate.dns_cert.arn
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_1a_id" {
  value = aws_subnet.public_1a.id
}

output "public_subnet_1b_id" {
  value = aws_subnet.public_1b.id
}

output "private_db_subnet_1a_id" {
  value = aws_subnet.private_db_1a.id
}

output "private_db_subnet_1b_id" {
  value = aws_subnet.private_db_1b.id
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "app_sg_id" {
  value = aws_security_group.app.id
}

output "open_vpn_sg_id" {
  value = aws_security_group.open_vpn.id
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "all_sg_id" {
  value = aws_security_group.all.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs.id
}

output "fe_ecr_repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "be_ecr_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}