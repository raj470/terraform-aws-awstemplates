provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["/Users/rajeshwarreddysirigada/.aws/credentials"]
}
resource "aws_instance" "terraform" {
  ami                    = var.ami
  tags                   = var.tags
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone      = var.availability_zone[1]
  key_name               = var.key_name
  user_data              = <<-EOF
    #!/bin/bash
    #sudo su
    yum install httpd -y
    systemctl status httpd
    systemctl start httpd
    cd /var/www/html
    cat << EOL > /var/www/html/index.html
    <!DOCTYPE html>
      <html>
        <head>
          <title>Apache Web Server</title>
        </head>
        <body>
          <h1>Raj Website 1</h1>
          <p>This is a amazon linux 2 Machine.</p>
        </body>
      </html>
    EOL
  EOF
}