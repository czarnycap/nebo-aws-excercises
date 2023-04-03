# Define input variables
variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "nebo" {
  description = "reference for current NEBO task in my jira"
  default = "NEBO-15"
}

# Define AWS provider
provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "nebo_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.nebo_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.nebo_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}b"
}

# Create internet gateway
resource "aws_internet_gateway" "nebo_igw" {
  vpc_id = aws_vpc.nebo_vpc.id
}

# Create route table for public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.nebo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nebo_igw.id
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create NAT gateway
resource "aws_nat_gateway" "nebo_nat_gateway" {
  allocation_id = aws_eip.nebo_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

# Create route table for private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.nebo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nebo_nat_gateway.id
  }
}

# Associate private subnet with private route table
resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create EIP for NAT gateway
resource "aws_eip" "nebo_eip" {
  vpc = true
}

output "vpc_id" {
  value = aws_vpc.nebo_vpc.id
}

output "subnet_public" {
  value = aws_subnet.public_subnet.id
}

output "subnet_private" {
  value = aws_subnet.private_subnet.id
}

