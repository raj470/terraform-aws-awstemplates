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