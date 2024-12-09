resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "cds-devops-rt-pri"
  }
}

resource "aws_route_table_association" "private_route_table_subnet_associations" {
  for_each = aws_subnet.subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "tgw" {
  for_each = toset([
    "10.10.128.0/24",
    "10.10.129.0/24",
    "10.10.130.0/23",
    "10.10.132.0/23",
    "0.0.0.0/0"
  ])

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = each.value
  transit_gateway_id     = local.tgw_id
}