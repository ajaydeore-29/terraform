resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = "aws_vpc.my_vpc.id"
    cidr_block = "10.0.0.0/20"
    avaibility_zone = "ap_south_1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = "aws_vpc.my_vpc.id"
    cidr_block = "10.0.16.0/20
    avaibility_zone = "ap_south_1b"
    tags = {
        Name = "private_subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "aws_vpc.my_vpc.id"
    tags = {
        Name = "igw"
    }
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags {
        Name = "nat_eip"
    }
}
 
resource "aws_nat_gateway" "nat" {
    subnet_id = "aws_subnet.public_subnet.id"
    allocation_id = "aws_eip.nat_eip.id"
    tags = {
        Name = "nat"
    }
}
resource "aws_route_table" "public_rt" {
    vpc_id = "aws_vpc.my_vpc.id"

    route {
        cidr_block = "0.0.0.0/0"
        tags {
            Name = public_rt"
        }
    }
}

resource "aws_route_table_association" "public_rt_asooc" {
    subnet_id = "asw_subnet.public_subnet.id"
    route_table_id = "aws_route_table.public_rt.id"
}

resource "aws_route_table" "private_rt" {
    vpc_id = "aws_vpc.my_vpc.id"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "aws_nat_gateway.nat.id"
        route {
            cidr_block = "0.0.0.0/0"
            nat_gateway_id = aws_nat_gateway.nat.id

        }   
        tags = {
            Name = "private_rt"
        }
    }
}

resource "aws_route_table_association" "private_rt_assoc" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id

}

resource "aws_security_group" "sg" {
    name = "my_sg"
    description = "my_sg"
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_block = ["0.0.0.0/0"]
    
    ingress {
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        cidr_block = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1'
        cidr_block = ["0.0.0.0/0]
    }
}

resource "aws_instance" "public_instance" {
    ami = "ami-01a00762f46d584a1"
    key_name = "key.pem"
    instance_type = "t3.micro"
    tags {
        Name = "public_instance"
    }
}

resource "aws_instance" "private_instance" {
    ami = "
}