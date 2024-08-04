resource "aws_instance" "terraform" {
  ami = var.ami
  tags = var.tags
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone = var.availability_zone[1]
}