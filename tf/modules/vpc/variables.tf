variable "vpc" {
  type = object({
    name        = string
    cidr_block  = string
  })
  
  description   = "Name and CIDR block for the VPC"
}

variable "public_subnets" {
  type  = map(object({
    cidr_block          = string
    availability_zone   = string
  }))

  description = "Map of public subnet name and its CIDR block and AZ"
}

variable "private_subnets" {
  type = map(object({
    cidr_block          = string
    availability_zone   = string
  }))

  description = "Map of private subnet name and its CIDR block and AZ"
}

variable "enable_internet_gateway" {
  type          = bool
  description   = "If true, create a internet gateway in the VPC"
  default       = true
}

variable "enable_nat_gateway" {
  type          = bool
  description   = "If true, create a NAT gateway (one per AZ)  public subnets"
  default       = true
}