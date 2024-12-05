provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.vpc_name}-subnet"
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = [aws_subnet.subnet.id]
}
