# Terraform Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.56.1"
    }
  }
}
provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/Users/rajeshwarreddysirigada/.aws/credentials"]
}

#provisioning using terraform modules
module "temp" {
  source  = "app.terraform.io/raj_aws/temp/aws"
  version = "0.0.3"
}
