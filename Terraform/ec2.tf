resource "aws_instance" "ec2_terraform" {
  ami                         = "ami-0a1179631ec8933d7"
  instance_type               = "t2.micro"
  key_name                    = "ec2"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-02b81fa009f7e2116"]
  tags = {
    Name = "raj"
  }
  provisioner "file" { #file provisioning
    source      = "/Users/rajeshwarreddysirigada/Desktop/git/awstemplates/EC2/index.html"
    destination = "/home/ec2-user/index.html"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = aws_instance.ec2_aws.key_name
    timeout     = "4m"
  }


}


#Using locals
# locals {
#   instance_type = "t2.micro"
#   ami = "ami-0a1179631ec8933d7"
#   tag = "locals_provision"
# }

# resource "aws_instance" "ec2_locals" {
#   instance_type = "${local.instance_type}"
#   ami = "${local.ami}"
#   tags = {
#     Name = "${local.tag}-tag"
#   }
# }