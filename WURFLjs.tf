module "WURFLjs-ap-northeast-2" {
  source             = "modules/WURFLjs"
  aws_region         = "ap-northeast-2"
  availability_zones = "2"
  autoscale_min = "1"
  autoscale_max = "3"
  instance_type = "d2.xlarge"
  spot_price    = "0.25"
  key_name      = "terraform-test-2"  
  edition       = "BE" # BE, CE, TMO
  config        = "config: staging-community.yml"
                #  config: production-community.yml
                #  config: staging-community.yml
                #  config: production-business.yml
                #  config: staging-business.yml
  public_subnets = ["${data.terraform_remote_state.core_state.vpc-ap-northeast-2.public-subnet_ids}"]
  vpc_main_id    = "${data.terraform_remote_state.core_state.vpc-ap-northeast-2.aws_vpc.main.id}"
  default_sec    = "${data.terraform_remote_state.core_state.vpc-ap-northeast-2.aws_default_security_group.default.id}"
}

output "vpc-ap-northeast-2.public-subnet_ids" {
  value = [ "${data.terraform_remote_state.core_state.vpc-ap-northeast-2.public-subnet_ids}" ]
}