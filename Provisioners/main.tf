provider "aws" {
    region = "us-east-1"
}

# Variable definition

variable "cidr" {
    default = "10.0.0.0/16"
}

# Create SSH Key Pair

resource "aws_key_pair" "example" {
    key_name = "terraform-demo-yash"
    public_key = file("~/.ssh/id_rsa.pub")
}

# Create VPC

resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
}

# Create Subnet

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1"
    map_public_ip_on_launch = true
}

# Create Internet Gateway

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
}

# Create Route Table

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.myvpc.id

    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

# Associate Route Table to Subnet

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.RT.id
}

# Create Security Group

resource "aws_security_group" "websg" {
    name = web
    vpc_id = aws_vpc.myvpc.id

    ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      name = "Web-sg"
    }
}




