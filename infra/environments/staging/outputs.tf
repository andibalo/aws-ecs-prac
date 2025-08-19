output "aws_vpc--two_tier_stg_vpc" {
  value = aws_vpc.two_tier_stg_vpc.id
}

output "aws_security_group--two_tier_stg_default_sg" {
  value = aws_security_group.two_tier_stg_default_sg.id
}

output "aws_security_group--two_tier_stg_alb_sg" {
  value = aws_security_group.two_tier_stg_alb_sg.id
}

output "aws_security_group--two_tier_stg_app_sg" {
  value = aws_security_group.two_tier_stg_app_sg.id
}

output "aws_security_group--two_tier_stg_open_vpn_sg" {
  value = aws_security_group.two_tier_stg_open_vpn_sg.id
}

output "aws_security_group--two_tier_stg_rds_sg" {
  value = aws_security_group.two_tier_stg_rds_sg.id
}

output "aws_security_group--two_tier_stg_all_sg" {
  value = aws_security_group.two_tier_stg_all_sg.id
}

output "aws_security_group--two_tier_stg_ecs_sg" {
  value = aws_security_group.two_tier_stg_ecs_sg.id
}
