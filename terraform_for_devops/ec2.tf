# Key Pair
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terraform-key-ec2.pub")
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terra-vpc"
  }
}

# Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "terra-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "terra-igw"
  }
}

# Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "terra-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "my_rta" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "TF generated security group"
  vpc_id      = aws_vpc.my_vpc.id   # ✅ Attach to your custom VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "automate-sg"
    Environment = local.env
}
}

# EC2 Instance
resource "aws_instance" "my_instance" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.my_key.key_name   # ✅ not hardcoded
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data = file("install_nginx.sh")

  root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = "Terra-automate"
    Environment = local.env
  }
}

