variable "aws_region" {}

provider "aws" {
  # abstract the version constraint into the vars.tf or elsewhere
  version                 = "~> 1.7"
  shared_credentials_file = "~/.aws/credentials"
  region                  = "${var.aws_region}"
}

// create instance

// DynamoDB
// reference https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html
resource "aws_dynamodb_table" "billing-engine" {
  name           = "imageengine_billing_staging" // rename this to something more generic - this is to be extended beyond imageengine
  hash_key       = "pk"
  range_key      = "insert_timestamp"
  read_capacity  = 23
  write_capacity = 720

  global_secondary_index {
    name            = "GLOBAL_INTERNALID_FROMTIMESTAMP"
    hash_key        = "internal_id"
    range_key       = "insert_timestamp"
    read_capacity   = 23
    write_capacity  = 720
    projection_type = "ALL"
  }

  global_secondary_index {
    name               = "GLOBAL_EXTERNALID_FROMTIMESTAMP"
    hash_key           = "external_id"
    range_key          = "from_timestamp"
    read_capacity      = 23
    write_capacity     = 720
    projection_type    = "INCLUDE"
    non_key_attributes = ["measure"]
  }

  global_secondary_index {
    name            = "GLOBAL_INSERT_TIMESTAMP"
    hash_key        = "insert_timestamp"
    read_capacity   = 23
    write_capacity  = 720
    projection_type = "ALL"
  }

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "insert_timestamp"
    type = "N"
  }

  attribute {
    name = "from_timestamp"
    type = "N"
  }

  attribute {
    name = "internal_id"
    type = "N"
  }

  attribute {
    name = "external_id"
    type = "S"
  }

  tags {
    Name        = "Billing Engine DynamoDB"
    Environment = "staging"
  }
}
