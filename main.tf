# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# VPC Resource with Tags
resource "aws_vpc" "fmc_ftd_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support       = true
  tags = {
    Name = "fmc-ftd-vpc"
  }
}

# Internet Gateway Resource with Tags
resource "aws_internet_gateway" "fmc_ftd_igw" {
  vpc_id = aws_vpc.fmc_ftd_vpc.id
  tags = {
    Name = "fmc-ftd-igw"
  }
}


# Public Subnet Resource with Tags
resource "aws_subnet" "fmc_public_subnet" {
  vpc_id            = aws_vpc.fmc_ftd_vpc.id
  cidr_block         = var.public_subnet_cidr_block
  availability_zone = var.public_subnet_az
  map_public_ip_on_launch = true
  tags = {
    Name = "fmc-public-subnet"
  }
}

# Private Subnet Resource with Tags
resource "aws_subnet" "fmc_private_subnet" {
  vpc_id            = aws_vpc.fmc_ftd_vpc.id
  cidr_block         = var.private_subnet_cidr_block
  availability_zone = var.private_subnet_az
  tags = {
    Name = "fmc-private-subnet"
  }
}

# Route Table Resources (Public and Private Subnets)
resource "aws_route_table" "fmc_public_route_table" {
  vpc_id = aws_vpc.fmc_ftd_vpc.id
  tags = {
    Name = "fmc-public-route-table"
  }
}

resource "aws_route_table" "fmc_private_route_table" {
  vpc_id = aws_vpc.fmc_ftd_vpc.id
  tags = {
    Name = "fmc-private-route-table"
  }
}

# Route Association (Public Subnet)
resource "aws_route" "fmc_public_route" {
  route_table_id  = aws_route_table.fmc_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id      = aws_internet_gateway.fmc_ftd_igw.id
}

# Route Association (Private Subnet) - Modify based on your deployment
resource "aws_route" "fmc_private_route" {
  route_table_id  = aws_route_table.fmc_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.fmc_ftd_igw
}

# VPC Main Route Table Association (Public and Private Subnets)
resource "aws_route_table_association" "fmc_public_subnet_association" {
  subnet_id      = aws_subnet.fmc_public_subnet.id
  route_table_id = aws_route_table.fmc_public_route_table.id
}

resource "aws_route_table_association" "fmc_private_subnet_association" {
  subnet_id      = aws_subnet.fmc_private_subnet.id
  route_table_id = aws_route_table.fmc_private_route_table.id
}

# Output Module (optional)
