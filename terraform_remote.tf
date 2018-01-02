#
# Remote state and lock files
# Usage: copy this file terraform_remote.tf into any directory that we will use to manage infrastruture or services

# Changing the key to something unique (been using the directory path) allows changes to be made to different parts of the infrastructure at the same time. 
#  
# If we decide we want to lock the entire infrastucture while making changes we ensure that all keys are the same. 
#  

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "xxxxxxxxxxxxxxxx-terraform-remote-state-storage-s3"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "us-east-2"
    key            = "terraform/test-1"
  }
}
