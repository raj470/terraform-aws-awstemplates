#!/bin/bash
sudo su
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
systemctl status docker
systemctl enable docker
sudo docker pull public.ecr.aws/e0i5p7n6/raj:web
sudo yum install -y awslogs
sudo service awslogs status
sudo service awslogs start
sudochkconfig awslogs on
sudo docker run \
 --log-driver=awslogs \
 --log-opt awslogs-region=us-east-1 \
 --log-opt awslogs-group=/var/log/docker/ \
 --log-opt awslogs-create-group=true \
 -d -p 8080:80 public.ecr.aws/e0i5p7n6/raj:web
systemctl restart awslogsd
