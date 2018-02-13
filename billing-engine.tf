// Create DynamoDB
module "billing-engine-staging" {
  source     = "modules/billing-engine"
  aws_region = "us-east-1"
}

