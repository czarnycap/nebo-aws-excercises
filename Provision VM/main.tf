# Define variables
variable "subnet_a_id" {}
variable "subnet_b_id" {}
variable "instance_key_pair" {}
variable "favourite_ami" {}
variable "default_vpc" {}
variable "region" {}
# Define AWS provider

provider "aws" {
  region = var.region
}




# Create security group for bastion host
resource "aws_security_group" "bastion_sg" {
  name_prefix = "bastion_sg"
  vpc_id = var.default_vpc
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for hosts in private subnets
resource "aws_security_group" "private_network_sg" {
  name_prefix = "private_network_sg"
  vpc_id = var.default_vpc
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create bastion host instance
resource "aws_instance" "bastion_host" {
  ami           = var.favourite_ami # Replace with your preferred AMI
  instance_type = "t2.micro"
  key_name      = var.instance_key_pair
  subnet_id     = var.subnet_a_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  tags = {
    Name = "Bastion Host"
  }
}

# Create EC2 private instances
resource "aws_instance" "instance_a" {
  ami           = var.favourite_ami 
  instance_type = "t2.micro"
  key_name      = var.instance_key_pair
  subnet_id     = var.subnet_a_id
  vpc_security_group_ids = [aws_security_group.private_network_sg.id]
  tags = {
    Name = "Instance A"
  }
}

resource "aws_instance" "instance_b" {
  ami           = var.favourite_ami 
  instance_type = "t2.micro"
  key_name      = var.instance_key_pair
  subnet_id     = var.subnet_b_id
  vpc_security_group_ids = [aws_security_group.private_network_sg.id]
  tags = {
    Name = "Instance B"
  }
}

# Output the public IP address of the bastion host
output "bastion_host_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

