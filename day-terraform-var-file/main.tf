module "vpc" {
    source = "./module/vpc"
    vpc_id = var.vpc_cidr {}
    public_subnet = var.public_subnet_cidr {}
    private_subnet = var.private_subnet_cidr {}
    public_az = var.public_az {}
    private_az = var.private_az
    ssh_port = var.ssh_port {}
    http_port = var.http_port {}
    sg_name = var.sg_name {}

    }

    module "ec2" {
        source = "./module/ec2"
        ami = var.ami {}
        instance_type = var.instance_type {}
        key_name = var.key_name {}
        sg_id = var.sg_id {}
        public_subnet_id = var.public_subnet_id {}
        private_subnet_id = var.private_subnet_id {}

    }