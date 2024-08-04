provider "aws" {
  region = "us-east-1"
}
module "awstemplates" {
  source  = "app.terraform.io/raj_aws/awstemplates/aws"
  version = "1.9.0"
}
resource "aws_instance" "terraform" {
  ami = var.ami
  tags = var.tags
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone = var.availability_zone[1]
  key_name = var.key_name
}