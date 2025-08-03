#!/bin/bash

## STAGING

# Import vpc
terraform import aws_vpc.two_tier_stg_vpc vpc-0d8eb46653bd7e4e9

# Import subnets
terraform import aws_subnet.two_tier_stg_public_subnet_1a subnet-02213ab9a86e8e429

terraform import aws_subnet.two_tier_stg_public_subnet_1b subnet-06d8ef44ee8a0aff3

terraform import aws_subnet.two_tier_stg_private_subnet_app_1a subnet-01a1140709e3990a5

terraform import aws_subnet.two_tier_stg_private_subnet_db_1a subnet-094ce15bddcc2d7cb

terraform import aws_subnet.two_tier_stg_private_subnet_db_1b subnet-0c014163ae851082f

# Import security groups
terraform import aws_security_group.two_tier_stg_default_sg sg-0956bcbbf88bad60b

terraform import aws_security_group.two_tier_stg_alb_sg sg-05a744146806de11a

terraform import aws_security_group.two_tier_stg_app_sg sg-0e57cb5562fb47408

terraform import aws_security_group.two_tier_stg_open_vpn_sg sg-03027ad6831fe872c

terraform import aws_security_group.two_tier_stg_rds_sg sg-0c7219bc912c33435

terraform import aws_security_group.two_tier_stg_all_sg sg-0e92cdc3b9b2f28a8

terraform import aws_security_group.two_tier_stg_ecs_sg sg-03cde29bdaedd1bc1

# Import internet gateway
terraform import aws_internet_gateway.two_tier_stg_igw igw-0b211e3e7afaf01e0

# Import route table
terraform import aws_route_table.two_tier_stg_default_rtb rtb-05c2d861224859e09

terraform import aws_route_table.two_tier_stg_rtb_public rtb-020c122def6f6f83e

terraform import aws_route_table.two_tier_stg_rtb_private rtb-0e33c7d68ae979a40

# Import ECS
terraform import aws_ecs_cluster.two_tier_stg_ecs_cluster TwoTierCluster

# Import ECR
terraform import aws_ecr_repository.two_tier_stg_fe ecs-prac/fe

terraform import aws_ecr_repository.two_tier_stg_be ecs-prac/be

# Import ACM
terraform import aws_acm_certificate.two_tier_stg_dns_cert arn:aws:acm:ap-southeast-1:276531032295:certificate/68440355-fea8-4275-9a3a-0e97288d06ab

# Import target groups
terraform import aws_lb_target_group.two_tier_stg_ecs_be_tg arn:aws:elasticloadbalancing:ap-southeast-1:276531032295:targetgroup/twotier-ecs-be-tg/79bc02474abdb088 
 
terraform import aws_lb_target_group.two_tier_stg_ecs_fe_tg arn:aws:elasticloadbalancing:ap-southeast-1:276531032295:targetgroup/twotier-ecs-fe-tg/140287d1e526109b 