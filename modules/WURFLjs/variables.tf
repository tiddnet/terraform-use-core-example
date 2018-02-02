variable "aws_region" {}
variable "vpc_main_id" {}
variable "default_sec" {}
variable "edition" {}

variable "public_subnets" {
  type = "list"
}

variable "availability_zones" {}
variable "autoscale_min" {}
variable "autoscale_max" {}
variable "instance_type" {}
variable "spot_price" {}
variable "key_name" {}
variable "config" {}
