variable "region" {
  type    = string
  default = "ap-southeast-1"
}
variable "app_name" {
  type    = string
  default = "three-tier"
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "ec2_key_name" {
  type = string
}