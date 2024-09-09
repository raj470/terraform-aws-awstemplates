resource "aws_instance" "ec2_terraform_remote-exec" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "ssh_keypair"
  availability_zone      = var.availability_zone[1]
  vpc_security_group_ids = var.vpc_security_group_ids
  #user_data              = data.template_file.user-data-container.rendered
  iam_instance_profile = aws_iam_instance_profile.instance-profile-remote.name
  provisioner "file" {
    source      = "${path.cwd}/docker-fp-remote.sh"
    destination = "/home/ec2-user/docker-fp-remote.sh"
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = "${file("/Users/rajeshwarreddysirigada/Desktop/git/awstemplates/Terraform/ECS/ssh_keypair")}"
      timeout     = "4m"
    }
  }
  provisioner "remote-exec" {
    inline = [
      "set -x",
      "chmod +x /home/ec2-user/docker-fp-remote.sh",
      "/home/ec2-user/docker-fp-remote.sh > /home/ec2-user/script.log 2>&1",
      "echo Hello >> script.log",
    ]  
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = "${file("/Users/rajeshwarreddysirigada/Desktop/git/awstemplates/Terraform/ECS/ssh_keypair")}"
      timeout     = "4m"
    }
  }
}

resource "aws_key_pair" "ssh-provisioner-remote" { #keypair creation private and public 
  key_name   = "ssh_keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFaz112Dimt+o0Pcvur/n95M3CMjk8YSWthn70pzt3Fnx9mT1w6UMuTVEv68eutNG3Uy63ETISdpGFR7fmXTmkriuIRzHN2VS9bfNZxQzEyODlNflRfzfzOKyMw3PW2LaUr6D0R1I7WfsV70+wEcd/a4rCtexwqsz/mJr+kKiLwMM4xWJm0EJkRHbr1Zh+jQat3nyIsk8Vm5gyEV+I5joo/8QQKQc6zAH9lpPhpKefGDFS5L1QsokRHb8g6tCdD2bSZ4P/oNcRCi8DxSHsBYAg4+K1vvlprFzEzlLALRL754ZGsG7FUo/lr1FryqozfE8PlUC7lIHSHQ9Gw7KpQH+N rajeshwarreddysirigada@Rajeshwars-MacBook-Pro.local"
}

data "template_file" "user-data-container-remote" {
  template = file("${path.module}/docker.tpl")
}

resource "aws_iam_role" "ec2-cloudwatch-access-remote" {
  name               = "ec2-cloudwatch-logs-remote-exec"
  assume_role_policy = templatefile("${path.cwd}/assume_role.tftpl", {})
}

resource "aws_iam_policy" "cloudwatchlogs-policy-remote" {
  name = "ec2-logs-policy-remote-exec"
  policy = templatefile("${path.cwd}/user_policy.tftpl", { //Template File reference
    ec2_policies = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
  })
  description = "The policy is used to access the container logs to the cloudwatch log group"
  tags = {
    Name = "ec2-acces-logs"
  }
}

resource "aws_iam_role_policy_attachment" "role-policy-remote" {
  role       = aws_iam_role.ec2-cloudwatch-access-remote.name
  policy_arn = aws_iam_policy.cloudwatchlogs-policy-remote.arn
}

resource "aws_iam_instance_profile" "instance-profile-remote" {
  name = "ec2-profile-remote-exec"
  role = aws_iam_role.ec2-cloudwatch-access-remote.name
}