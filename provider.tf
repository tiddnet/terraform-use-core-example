# Configure the AWS Provider
provider "aws" {
  version = "~> 1.7"
  shared_credentials_file = "~/.aws/credentials"
  region                  = "${var.region}"
}
