# EC2
resource "aws_instance" "open_vpn" {
  ami                                  = "ami-0933f1385008d33c4"
  associate_public_ip_address          = true
  availability_zone                    = "ap-southeast-1a"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = true
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3.micro"
  key_name                             = var.ec2_key_name
  source_dest_check                    = true
  spot_instance_request_id             = null
  subnet_id                            = data.terraform_remote_state.main.outputs.public_subnet_1a_id

  user_data = data.local_file.start_openvpn_sh.content
  tags = {
    "Name" = "open-vpn"
  }
  tenancy = "default"
  vpc_security_group_ids = [
    data.terraform_remote_state.main.outputs.open_vpn_sg_id,
  ]

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    amd_sev_snp      = null
    core_count       = 1
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  enclave_options {
    enabled = false
  }

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record    = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null
    tags                  = {}
    tags_all              = {}
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}