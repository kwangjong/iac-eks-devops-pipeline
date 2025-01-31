#vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc.cidr_block
  
  tags = {
    Name = var.vpc.name
  }
}

#subnet
resource "aws_subnet" "public_subnet" {
  for_each          = var.public_subnet
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  
  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "private_subnet" {
  for_each          = var.private_subnet
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  
  tags = {
    Name = each.key
  }
}

#igw
resource "aws_internet_gateway" "igw" {
  vpc_id    = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc.name}-igw"
  }
}

#nat
resource "aws_eip" "nat" {
  for_each  = var.nat_gateway
  domain    = "vpc"
  
  tags = {
    Name = "${each.key}-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each      = var.nat_gateway
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public_subnet[each.value.public_subnet_name].id

  tags = {
    Name = each.key
  }
}

#public route table
resource "aws_route_table" "public" {
  for_each  = var.public_route_table
  vpc_id    = aws_vpc.vpc.id

  tags = {
    Name = each.key
  }
}

resource "aws_route" "public_default_route" {
  for_each                = var.public_route_table
  route_table_id          = aws_route_table.public[each.key].id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw.id
  
  depends_on = [ 
    aws_internet_gateway.igw 
  ]
}

resource "aws_route_table_association" "public_assoc" {
  for_each        = merge([
    for route_table_name, value in var.public_route_table : {
      for subnet_name in value.public_subnet_name : 
        "${route_table_name}-${subnet_name}" => {
          route_table_id  = aws_route_table.public[route_table_name].id
          subnet_id       = aws_subnet.public_subnet[subnet_name].id
        }
    }
  ])

  subnet_id       = each.value.subnet_id
  route_table_id  = each.value.route_table_id
}

#private route table
resource "aws_route_table" "private" {
  for_each  = var.private_route_table
  vpc_id    = aws_vpc.vpc.id

  tags = {
    Name = each.key
  }
}

resource "aws_route" "private_default_route" {
  for_each                  = var.private_route_table
  route_table_id            = aws_route_table.private[each.key].id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.nat[each.value.nat_gateway_name].id
  
  depends_on = [ 
    aws_nat_gateway.nat 
  ]
}

resource "aws_route_table_association" "private_assoc" {
  for_each        = merge([
    for route_table_name, value in var.private_route_table : {
      for subnet_name in value.private_subnet_name : 
        "${route_table_name}-${subnet_name}" => {
          route_table_id  = aws_route_table.private[route_table_name].id
          subnet_id       = aws_subnet.private_subnet[subnet_name].id
        }
    }
  ])
  subnet_id       = each.value.subnet_id
  route_table_id  = each.value.route_table_id
}
