resource "aws_instance" "ec2_terraform" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  availability_zone      = var.availability_zone[2]
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = data.template_file.user-data-container.rendered
  iam_instance_profile   = aws_iam_instance_profile.instance-profile.name
}

data "template_file" "user-data-container" {
  template = file("${path.module}/docker.tpl")
}

resource "aws_iam_role" "ec2-cloudwatch-access" {
  name               = "ec2-cloudwatch-logs"
  assume_role_policy = templatefile("${path.cwd}/assume_role.tftpl", {})
}

resource "aws_iam_policy" "cloudwatchlogs-policy" {
  name = "ec2-logs-policy"
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

resource "aws_iam_role_policy_attachment" "role-policy" {
  role       = aws_iam_role.ec2-cloudwatch-access.name
  policy_arn = aws_iam_policy.cloudwatchlogs-policy.arn
}

resource "aws_iam_instance_profile" "instance-profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2-cloudwatch-access.name
}








# [/var/lib/docker/containers/]
# datetime_format = %b %d %H:%M:%S
# file = /var/lib/docker/containers/*/container-cached.log
# buffer_duration = 2000
# initial_position = start_of_file
# log_group_name = /var/ib/docker
# -- INSERT --                       






















# resource "aws_instance" "container-logs" {
#   ami                    = var.ami
#   tags                   = var.tags
#   instance_type          = var.instance_type
#   vpc_security_group_ids = var.vpc_security_group_ids
#   availability_zone      = var.availability_zone[1]
#   key_name               = var.key_name
#   user_data = data.template_cloudinit_config.config-files.rendered#base64decode(filebase64("${path.cwd}")/docker_logs.tf))
# }

# resource "template_dir" "path-to-files" {
#   source_dir = "${data.template_cloudinit_config.config-files.rendered}"
#   destination_dir = "${path.root}/var/www/html/"
# }

# data "template_cloudinit_config" "config-files" {
#   base64_encode = false
#   gzip = false

#   part {
#     # filename = "DockerFile"
#     # content_type = "dockerfile/config"
#     content = templatefile("${path.cwd}/DockerFile", {})
#   }
#   part {
#     filename = "apache.sh"
#     content_type = "Apache/install"
#     content = templatefile("${path.cwd}/apache.sh", {})
#   }
#   part {
#     filename = "index.html"
#     content_type = "indexfile"
#     content = templatefile("${path.cwd}/index.html",{})
#   }
# #   template = "${file("${path.module}/DockerFile")}" #file("${path.module}/cloudwatchlogs/DockerFile.tpl")
# }

# data "template_file" "docker-log" {
#   template = "${file("${path.module}/DockerFile")}"
# }


# output "rendered-output" {
#   value = data.template_cloudinit_config.config-files.rendered#base64decode(filebase64(data.template_cloudinit_config.config-files.rendered))
# }