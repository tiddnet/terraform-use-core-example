data "terraform_remote_state" "core_state" {
  backend = "s3"

  config {
    encrypt = true
    bucket  = "xxxxxxxxxxxxxxxx-terraform-remote-state-storage-s3"
    region  = "us-east-2"
    key     = "terraform/core"
  }
}
