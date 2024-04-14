variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
}

variable "vpc_ipv6_cidr_block" {
  description = "The IPV6 CIDR block for the VPC"
}

# Variable for Subnet CIDR Blocks
variable "public_subnet_cidr_block" {
  type = string
}

variable "private_subnet_cidr_block" {
  type = string
}

# Variable for Availability Zone
variable "public_subnet_az" {
  type = string
}

variable "private_subnet_az" {
  type = string
}