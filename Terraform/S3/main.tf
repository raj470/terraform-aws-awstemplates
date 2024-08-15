#Terraform Configuration
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">=5.56.1"
    }
  }
}
#Provider Configuration
provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["/Users/rajeshwarreddysirigada/.aws/credentials"]
}
#Resource Creation
resource "aws_s3_bucket" "bucket_name" {
  bucket = var.bucket_name
  force_destroy = var.destroy
  tags = {
    Name = var.Name
  }
}
