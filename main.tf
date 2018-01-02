resource "aws_route53_record" "main" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "test.${data.aws_route53_zone.main.name}"
  type    = "A"
  ttl     = "300"
  records = ["127.0.1.1"]
}

data "aws_route53_zone" "main" {
  name = "scientiamobile.co.za."
}

// Read the terraform_remote_state from the s3 bucket, and expose as core_state. 
data "terraform_remote_state" "core_state" {
  backend = "s3"

  config {
    encrypt = true
    bucket  = "${var.core_state_bucket}"
    region  = "${var.core_state_region}"
    key     = "${var.core_state_key}"
  }
}
