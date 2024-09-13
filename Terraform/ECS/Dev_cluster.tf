terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.63.0"
    }
  }
}
terraform {
  cloud {

    organization = "raj_aws"

    workspaces {
      name = "dev"
    }
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/Users/rajeshwarreddysirigada/.aws/credentials"]
}
#New KeyPair generating
resource "aws_key_pair" "ssh_keygen" {
  key_name   = "ssh_keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFaz112Dimt+o0Pcvur/n95M3CMjk8YSWthn70pzt3Fnx9mT1w6UMuTVEv68eutNG3Uy63ETISdpGFR7fmXTmkriuIRzHN2VS9bfNZxQzEyODlNflRfzfzOKyMw3PW2LaUr6D0R1I7WfsV70+wEcd/a4rCtexwqsz/mJr+kKiLwMM4xWJm0EJkRHbr1Zh+jQat3nyIsk8Vm5gyEV+I5joo/8QQKQc6zAH9lpPhpKefGDFS5L1QsokRHb8g6tCdD2bSZ4P/oNcRCi8DxSHsBYAg4+K1vvlprFzEzlLALRL754ZGsG7FUo/lr1FryqozfE8PlUC7lIHSHQ9Gw7KpQH+N rajeshwarreddysirigada@Rajeshwars-MacBook-Pro.local"
  tags = {
    "key" = var.multiple_tags.Key_pair
  }
}
#ECS Cluster Creation
resource "aws_ecs_cluster" "App_ecs" {
  name = "Terraform_provisioning_ECScluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
#ECS Task Definition
resource "aws_ecs_task_definition" "TD-cluster" {
  depends_on = [ aws_cloudwatch_log_group.logs_group ]
  family = "TF_Prov_Dev"
  container_definitions = jsonencode([
    {
      name      = "jenkins-app"
      image     = "public.ecr.aws/e0i5p7n6/jenkins:latest"
      essential = true
      portMappings = [{
        containerPort = 8080
        hostPort      = 8080
        protocol      = "tcp"
        name = "containerport"
        appprotocol  = "http"
      }]
      # HealthCheck = {
      #   command     = ["CMD-SHELL", "curl -f http://localhost/ || exit 1"]
      #   Interval    = 30
      #   Retries     = 3
      #   StartPeriod = 20
      #   Timeout     = 30
      # }
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost/ || exit 1"]
        interval    = 30
        retries     = 3
        startPeriod = 20
        timeout     = 30
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.logs_group.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
          awslogs-create-group  = "true"
          # max-buffer-duration   = "25"
        }
      }

    }
  ])
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
  execution_role_arn = "arn:aws:iam::058264186519:role/ecsTaskExecutionRole"
}
#IAM role for task execution
# resource "aws_ecs_capacity_provider" "capacity-provider" {

# }

# Task Log group
resource "aws_cloudwatch_log_group" "logs_group" {
  name = "/ecs/"
}
#Service creation
resource "aws_ecs_service" "tf_service" {
  name                = "tf_prov_service"
  cluster             = aws_ecs_cluster.App_ecs.id
  desired_count       = 1
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  task_definition     = aws_ecs_task_definition.TD-cluster.arn
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  network_configuration {
    security_groups = ["sg-06dce10db069bee9d"]
    subnets         = ["subnet-02075efeb8ebfe991", "subnet-04287cde12f035e08", "subnet-01ed866330e76671e", "subnet-04df54f17d3907e9b"]
  }
}

#Auto Scaling Group Creation
resource "aws_appautoscaling_target" "fargate_scaling_target" {
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${aws_ecs_cluster.App_ecs.name}/${aws_ecs_service.tf_service.name}"
  min_capacity       = 1
  max_capacity       = 10
}

resource "aws_appautoscaling_policy" "fargate_scaling_policy" {
  depends_on = [ aws_appautoscaling_target.fargate_scaling_target ]
  name               = "fargate-scaling-policy"
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${aws_ecs_cluster.App_ecs.name}/${aws_ecs_service.tf_service.name}"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 50.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}



#capacity provider 
# resource "aws_ecs_capacity_provider" "test-cp" {
#   name = "clustercp"
#   depends_on = [ aws_appautoscaling_target.fargate_scaling_target ]
#   auto_scaling_group_provider {
#     auto_scaling_group_arn = aws_appautoscaling_target.fargate_scaling_target.arn
#     managed_draining = "ENABLED"
#     managed_scaling {
#       maximum_scaling_step_size = 10
#       minimum_scaling_step_size = 1
#       status = "ENABLED"
#       target_capacity = 65
#     }
#   }
# }

#capacity provider association
resource "aws_ecs_cluster_capacity_providers" "ecs-cp-asg" {
  cluster_name       = aws_ecs_cluster.App_ecs.name
  capacity_providers = ["FARGATE"]
  # default_capacity_provider_strategy {
  #   base              = 1
  #   weight            = 100
  #   capacity_provider = "FARGATE"
  # }
}

# resource "aws_autoscaling_group" "ASG_prov" {
#   availability_zones = var.availability_zone[1]
#   max_size = 8
#   min_size = 2
#   health_check_grace_period = 60
#   health_check_type = "ELB"
#   instance_maintenance_policy {
#     max_healthy_percentage = 200
#     min_healthy_percentage = 100
#   }
#   desired_capacity = 3
#   desired_capacity_type = "units"
#   name = "ASG-tf-prov"
#   tag {
#     key = var.multiple_tags.ASG-tag
#     value = var.multiple_tags.ASG-tag
#     propagate_at_launch = true
#   }
# }



#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "raj_aws"

#     workspaces {
#       prefix =  "dev"
#     }
#   }

# #######
# # variables.tf

# variable "private_subnet_names" {
#   type    = list(string)
#   default = ["private_subnet_a", "private_subnet_b", "private_subnet_c"]
# }
# variable "vpc_cidr" {
#   type    = string
#   default = "10.0.0.0/16"
# }
# variable "public_subnet_names" {
#   type    = list(string)
#   default = ["public_subnet_1", "public_subnet_2"]
# }
# # main.tf

# resource "aws_subnet" "private_subnet" {
#   count             = length(var.private_subnet_names)
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
#   availability_zone = data.aws_availability_zones.available.names[count.index]

#   tags = {
#     Name      = var.private_subnet_names[count.index]
#     Terraform = "true"
#   }
# }
































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