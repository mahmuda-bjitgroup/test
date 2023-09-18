resource "aws_vpc" "mahmuda_vpc" {
  cidr_block = "192.168.0.0/26"

  tags = {
    Name = "mahmuda_vpc"
  }
}

#Creating public subnet
resource "aws_subnet" "mahmuda_subnet_1" {
  vpc_id                  = aws_vpc.mahmuda_vpc.id
  cidr_block              = "192.168.0.0/27" #first public subnet
  availability_zone       = "us-east-1a"
  # map_public_ip_on_launch = true #ensures the public ip of an instance

  tags = {
    Name = "Public Subnet 1"
  }
}

#Creating private subnet
resource "aws_subnet" "mahmuda_subnet_2" {
  vpc_id            = aws_vpc.mahmuda_vpc.id
  cidr_block        = "192.168.0.32/27" #first public subnet
  availability_zone = "us-east-1b"
  #   map_public_ip_on_launch = true #ensures the public ip of an instance

  tags = {
    Name = "Private Subnet 2"
  }
}

#Internet gateway for vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mahmuda_vpc.id

  tags = {
    Name = "pubsub-1-igw"
  }
}

# Creating route table
resource "aws_route_table" "pubsub-1-rt" {
  vpc_id = aws_vpc.mahmuda_vpc.id #required

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pubsub-1-rt"
  }
}

# Subnet association to route table
resource "aws_route_table_association" "pubsub_1_association" {
  subnet_id      = aws_subnet.mahmuda_subnet_1.id
  route_table_id = aws_route_table.pubsub-1-rt.id
}

# Create Security Group - SSH Traffic
resource "aws_security_group" "vpc-ssh" {
  name        = "vpc-ssh"
  description = "terraform-sg"

  # description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.mahmuda_vpc.id
  ingress {
    description = "Allow Port 22 for SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "Allow Port 443 for TCP"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    description = "Allow all IP and Ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}