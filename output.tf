output "data.aws_route53_delegation_set.main.id" {
  value = "${data.terraform_remote_state.core_state.aws_route53_delegation_set.main.id}"
}
