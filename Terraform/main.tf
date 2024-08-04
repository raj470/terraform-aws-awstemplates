# Terraform Configuration
terraform {
   required_providers {
      aws = {
        source = "hashicorp/aws"
        version = ">=5.56.1"
      }
    }
}
provider "aws" {
  region = "us-east-1"
}

module "temp" {
  source  = "app.terraform.io/raj_aws/temp/aws"
  version = "0.0.2"
}
#   credentials "app.terraform.io" {
#   # valid user API token
#   token = "xxxxxx.atlasv1.zzzzzzzzzzzzz"
# }