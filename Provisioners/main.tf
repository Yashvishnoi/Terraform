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
    public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

# Create VPC

resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
}

# Create Subnet

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

# Create Internet Gateway

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
}

# Create Route Table

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.myvpc.id

    route {
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
    name = "web"
    vpc_id = aws_vpc.myvpc.id

    # HTTP Traffic from anywhere.
    ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # SSH from Anywhere 
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # This allows all outbound traffic, Instances can access the internet
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "Web-sg"
    }
}

resource "aws_instance" "server" {
    ami = "ami-0b6c6ebed2801a5cb"
    instance_type = "t3.micro"
    key_name = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.websg.id]
    subnet_id = aws_subnet.sub1.id

    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file(pathexpand("~/.ssh/id_ed25519"))
        host = self.public_ip
    }

    # File provisioner to copy a file from local to remote EC2 instance
    provisioner "file" {
        source = "app.py"
        destination = "/home/ubuntu/app.py"
    }
    provisioner "remote-exec" {
        inline = [
		"echo 'Hello from remote instance'",
		"sudo apt update",
  		"sudo apt install python3-pip -y",
  		"sudo apt install python3-flask -y",
    		"sudo nohup python3 /home/ubuntu/app.py > output.log 2>&1 &"
        ]
    }
}





