#vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc.cidr_block
  
  tags = {
    Name = var.vpc.name
  }
}

#subnet
resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  
  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  
  tags = {
    Name = each.key
  }
}

#igw
resource "aws_internet_gateway" "igw" {
  count     = var.enable_internet_gateway ? 1 : 0
  vpc_id    = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc.name}-igw"
  }
}

#nat
locals {
  availability_zone = toset(distinct([
    for k, v in var.public_subnets : v.availability_zone
  ]))
}

locals {
    public_subnet_by_az = {
        for k, v in aws_subnet.public_subnets : v.availability_zone => v
    }
}

resource "aws_eip" "nat" {
  for_each  = var.enable_nat_gateway ? toset(local.availability_zone) : {}
  domain    = "vpc"
  
  tags = {
    Name = "${var.vpc.name}-${each.key}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each      = var.enable_nat_gateway? local.availability_zone : {}
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = local.public_subnet_by_az[each.key].id

  tags = {
    Name = each.key
  }
}

#public route table
resource "aws_route_table" "public" {
  count   = length(var.public_subnets) == 0 ? 1 : 0
  vpc_id  = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc.name}-public-rt"
  }
}

resource "aws_route" "public_default_route" {
  count                   = enable_internet_gateway ? 1 : 0
  route_table_id          = aws_route_table.public[0].id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw[0].id
  
  depends_on = [ 
    aws_internet_gateway.igw 
  ]
}

resource "aws_route_table_association" "public_assoc" {
  for_each        = enable_internet_gateway ? var.public_subnets : {}
  subnet_id       = each.value.id
  route_table_id  = aws_route_table.public[0].id
}

#private route table
resource "aws_route_table" "private" {
  for_each  = local.availability_zone
  vpc_id    = aws_vpc.vpc

  tags = {
    Name = "${var.vpc.name}-${each.key}-private-rt"
  }
}

resource "aws_route" "private_default_route" {
  for_each                  = enable_nat_gateway ? local.availability_zone : {}
  route_table_id            = aws_route_table.private[each.key].id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id                = aws_nat_gateway.nat[each.key].id
  
  depends_on = [ 
    aws_nat_gateway.nat 
  ]
}

resource "aws_route_table_association" "private_assoc" {
  for_each        = aws_subnet.private_subnets
  subnet_id       = each.value.id
  route_table_id  = aws_route_table.private[each.value.availability_zone].id
}
