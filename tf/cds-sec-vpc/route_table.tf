# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "sec-rt-pub"
  }
}

resource "aws_route_table_association" "public_route_table_subnet_associations" {
  for_each = toset([
    "sec-sbn-comm-pub-a",
    "sec-sbn-comm-pub-c"
  ])

  subnet_id      = aws_subnet.subnets[each.value].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "pub_igw" {
  route_table_id         = aws_route_table.public.id 
  destination_cidr_block = "0.0.0.0/0" 
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "pub_tgw" {
  for_each = toset([
    "10.10.129.0/24",
    "10.10.130.0/23", 
    "10.10.132.0/23",
    "10.10.143.0/24"
  ])

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

# private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "sec-rt-pri"
  }
}

resource "aws_route_table_association" "private_route_table_subnet_associations" {
  for_each = toset([
    "sec-sbn-comm-pri-a",
    "sec-sbn-comm-pri-c",
    "sec-sbn-ap-pri-a",
    "sec-sbn-ap-pri-c"
  ])

  subnet_id      = aws_subnet.subnets[each.value].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "pri_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route" "pri_tgw" {
  for_each = toset([
    "10.10.129.0/24",
    "10.10.130.0/23", 
    "10.10.132.0/23",
    "10.10.143.0/24"
  ])

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}