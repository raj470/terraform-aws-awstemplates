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

#locals
locals {
  provision_file = "${var.bucket_name}-bkt"
}

#Resource Creation
resource "aws_s3_bucket" "bucket_name" {
  bucket = local.provision_file #using locals in terraform
  force_destroy = var.destroy
  tags = {
    Name = var.Name
  }
}

resource "aws_s3_bucket_accelerate_configuration" "bucket_transfer_acceleration" {
  bucket = aws_s3_bucket.bucket_name.id
  status = var.status
}

resource "aws_s3_bucket_ownership_controls" "object_ownership" {
  bucket = aws_s3_bucket.bucket_name.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.bucket_name.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.object_ownership,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.bucket_name.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket_name.id
  versioning_configuration {
    status = "Enabled"
  }
}

#terraform init
#terraform plan -var-file="variable.tfvars"
#terraform apply -var-file="variable.tfvars" -auto-approve
