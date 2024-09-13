# import {
#   to = aws_ecs_cluster.fargate
#   id = "arn:aws:ecs:us-east-1:058264186519:cluster/fargate"
# }

resource "aws_ecs_cluster" "fargate1" {
  name = "fargate"
}
resource "aws_ecs_cluster" "fargate2" {
  name = "fargate"
}


resource "aws_ecs_cluster_capacity_providers" "FARGATE_SPOT" {
  cluster_name = "fargate"
}
