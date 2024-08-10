output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.terraform.id
}
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.terraform.public_ip
}
output "vpc_security_group_ids" {
  description = "Security group ID"
  value       = aws_instance.terraform.vpc_security_group_ids
}
output "ami" {
  description = "The ami of instance"
  value       = aws_instance.terraform.ami
}