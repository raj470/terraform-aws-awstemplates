resource "aws_instance" "ec2_terraform" {
    ami = "ami-0a1179631ec8933d7"
    instance_type = "t2.micro"
    key_name = "ec2"
    associate_public_ip_address = true
    vpc_security_group_ids = ["sg-02b81fa009f7e2116"]
    tags = {
        Name = "raj"
    }
    

}