variable "app_name" {
  type        = string
  default     = "three-tier"
}

variable "environment" {
  type        = string
  default     = "staging"
}

variable "ec2_ssh_public_key" {
  type        = string
}
