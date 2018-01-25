# Configure the AWS Provider
provider "aws" {
  version = "~>1.7"
  shared_credentials_file = "~/.aws/credentials"
  region                  = "${var.aws_region}"
}

# security groups (443, 80) 0.0.0.0/0
# S3 bucket
# instance c3.xlarge

# elb 
# - 80, 443  no stickiness
# - security group
# - idle timeout 60 seconds
# - access logs - enabled 5 minutes S3 location 
# - Cross-zone load balancing enabled.

data "aws_ami" "WURFLjs-green" {
  most_recent = true

  filter {
    name   = "tag:Product"
    values = ["WURFL.js"]
  }

  filter {
    name   = "tag:Color"
    values = ["Green"]
  }


  owners = ["self"] # Canonical
}


resource "aws_elb" "WURFLjs-green" {
  name            = "WURFLjs-${var.edition}-green"
  subnets         = ["${var.public_subnets}"]
  security_groups = ["${aws_security_group.instance.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 10
    timeout             = 10
    target              = "HTTP:80/health.php"
    interval            = 20
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}




resource "aws_route53_record" "WURFLjs-green" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "test2.${data.aws_route53_zone.main.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "${aws_elb.WURFLjs-green.dns_name}",
  ]

    set_identifier = "WURFLjs-${var.edition}"
    latency_routing_policy  {
        region = "${var.aws_region}"
    }

}

data "aws_route53_zone" "main" {
  name = "scientiamobile.co.za."
}

# green
resource "aws_launch_configuration" "WURFLjs-green" {
  name_prefix   = "WURFLjs-${var.edition}_"
  image_id      = "${data.aws_ami.WURFLjs-green.id}"
  instance_type = "${var.instance_type}"
  spot_price    = "${var.spot_price}"
  key_name      = "${var.key_name}"

  security_groups = ["${aws_security_group.instance.id}", "${var.default_sec}"]

  user_data = <<-EOF
               # WURFL.js Environment Configuration File
               #   /u/apps/wurfljs/env
               "${var.config}"
               # config: production-community.yml
               # config: staging-community.yml
               # config: production-business.yml
               # config: staging-business.yml
               EOF


  # may want to remove this, or abstract it.
  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    delete_on_termination = true
  }
  ephemeral_block_device {
    device_name  = "/dev/xvdb"
    virtual_name = "ephemeral0"
  }
  ephemeral_block_device {
    device_name  = "/dev/xvdc"
    virtual_name = "ephemeral1"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "WURFLjs-green" {
  name                 = "WURFL.js ${var.edition} (G) - ${aws_launch_configuration.WURFLjs-green.name}"
  min_size             = "${var.autoscale_min}"
  max_size             = "${var.autoscale_max}"
  min_elb_capacity     = "${var.autoscale_min}"
  launch_configuration = "${aws_launch_configuration.WURFLjs-green.id}"
  health_check_type    = "ELB"
  load_balancers       = ["${aws_elb.WURFLjs-green.id}"]
  termination_policies = ["OldestLaunchConfiguration"]
  vpc_zone_identifier  = ["${var.public_subnets[0]}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name   = "http"
  vpc_id = "${var.vpc_main_id}"

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # aws_launch_configuration.launch_configuration in this module sets create_before_destroy to true, which means
  # everything it depends on, including this resource, must set it as well, or you'll get cyclic dependency errors
  # when you try to do a terraform destroy.
  lifecycle {
    create_before_destroy = true
  }
}
