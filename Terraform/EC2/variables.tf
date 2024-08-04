variable "region" {
   description = "AWS Region"
   default = "us-east-1"
}
variable "instance_type" {
  description = "Instance Type"
  default = "t2.micro"
}
variable "instance_name" {
  description = "EC2 Instance Name"
  default = "Provisioned by Terraform"
}
variable "ami" {
  description = "AMI for instance"
  default = "ami-0a1179631ec8933d7"
}
variable "tags" {
  type = map(string)
  description = "Tagging the resource"
  default = {
    "Enivornment" = "prod"
    "Provisioned" = "terraform"
  }
}
variable "vpc_security_group_ids" {
  description = "VPC Security Groups"
  default = "vpc-05d42dad479891e15"
}
variable "availability_zone" {
  description = "Defining availability_zone"
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}