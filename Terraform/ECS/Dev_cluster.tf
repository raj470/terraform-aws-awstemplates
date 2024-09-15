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
      healthCheck = {
        command     = ["CMD-SHELL","curl -f http://localhost:8080/login || exit 1"]
        interval: 30
        timeout: 20
        retries: 4
        startPeriod: 30
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
# Task Log group
resource "aws_cloudwatch_log_group" "logs_group" {
  name = "/ecs/jenkins-lts/"
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
    assign_public_ip = true
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
