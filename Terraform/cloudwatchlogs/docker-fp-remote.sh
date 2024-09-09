#!/bin/bash
sudo yum update -y
echo "Running the script..."
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo docker pull public.ecr.aws/e0i5p7n6/raj:web
sudo yum install -y awslogs
sudo systemctl start awslogsd
sudo systemctl status awslogsd
sudo chkconfig awslogsd on
sudo docker run -d -p 8080:80 public.ecr.aws/e0i5p7n6/raj:web
container_id=$(sudo ls /var/lib/docker/containers/ | grep -o '[a-f0-9]\{64\}')
echo "Container ID: $container_id"
cat <<EOF | sudo tee -a /etc/awslogs/awslogs.conf
[/var/lib/docker]
datetime_format = %b %d %H:%M:%S
buffer_duration = 5000
file = /var/lib/docker/containers/${container_id}/${container_id}-json.log
log_stream_name = ${container_id}
initial_position = start_of_file
log_group_name = /var/log/docker/
EOF
sudo systemctl restart awslogsd
exit 0