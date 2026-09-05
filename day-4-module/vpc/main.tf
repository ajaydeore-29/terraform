resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    tags {
        Name = "my_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    cidr_block = "10.0.0.0/20"
    vpc_id = aws_vpc.my_vpc.vpc_id
    availability_zone = "ap_south_1a"
    map_public_on_launch = true
    tags {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    cidr_block = "10.0.16.0/20"
    vpc_id = aws_vpc.my_vpc.id 
    availability_zone = "ap_south_1b"
    tags {
        Name = "private_subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags {
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
    subnet_id = aws_subnet.public_subnet.id
    allocation_id = aws_eip.nat_eip.id

    tags {
        Name = "nat"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    internet_gateway = aws_internet_gateway.igw.id
    }
    tags {
        Name = "public_rt"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public_subnet.id
    route_table = aws_route_table.public_rt.id
}


resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags {
        Name = "private_rt"
    }
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private_subnet.id
    route_table = aws_route_table.private_rt.id
}

resource "aws_security_group" "my_sg" {
    Name = "my_sg"
    discription = "my_sg"
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_block = "0.0.0.0/0
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_block = "0.0.0.0/0/
    }

    egress {
        from_port = 0 
        to_port = 0
        protocol = "-1"
        cidr_block = "0.0.0.0/0"

    }
    tags {
        Name = "my_sg"
    }
}

