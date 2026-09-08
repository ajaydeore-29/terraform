resource "aws_instance" "public_instance" {
    ami = "ami-090d68841c2a28756"
    instance_type = "t3.micro"
    key_name = "keypair"
    vpc_security_group_id = "sg-09ed805398845d1c1"
    tags = {
        Name = "public_instance"
    }
}

