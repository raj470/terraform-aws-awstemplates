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

module "temp" {
  source  = "app.terraform.io/raj_aws/temp/aws"
  version = "0.0.3"
}

locals {
  instance_type = "t2.micro"
  ami = "ami-0a1179631ec8933d7"
  tag = "locals_provision"
}

resource "aws_instance" "ec2_locals" {
  instance_type = "${local.instance_type}"
  ami = "${local.ami}"
  tags = {
    Name = "${local.tag}-tag"
  }
}
