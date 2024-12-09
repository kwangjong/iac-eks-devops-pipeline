resource "aws_vpc" "vpc" {
  cidr_block = "10.10.128.0/24"
  tags = {
    Name = "cds-sec-vpc"
  }
}

resource "aws_subnet" "subnets" {
  for_each = {
    "sec-sbn-comm-pub-a" = {
      cidr_block        = "10.10.128.0/27"
      availability_zone = "ap-northeast-2a"
    }
    "sec-sbn-comm-pub-c" = {
      cidr_block        = "10.10.128.32/27"
      availability_zone = "ap-northeast-2c"
    }
    "sec-sbn-comm-pri-a" = {
      cidr_block        = "10.10.128.64/27"
      availability_zone = "ap-northeast-2a"
    }
    "sec-sbn-comm-pri-c" = {
      cidr_block        = "10.10.128.96/27"
      availability_zone = "ap-northeast-2c"
    }
    "sec-sbn-ap-pri-a" = {
      cidr_block        = "10.10.128.128/27"
      availability_zone = "ap-northeast-2a"
    }
    "sec-sbn-ap-pri-c" = {
      cidr_block        = "10.10.128.160/27"
      availability_zone = "ap-northeast-2c"
    }
  }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnets["sec-sbn-comm-pub-a"].id

  tags = {
    Name = "sec-nat"
  }
}

resource "aws_ec2_transit_gateway" "tgw" {
  tags = {
    Name = "cds-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachments" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc.id
  subnet_ids         = [
    aws_subnet.subnets["sec-sbn-comm-pri-a"].id,
    aws_subnet.subnets["sec-sbn-comm-pri-c"].id
  ]
  tags = {
    Name = "sec-tgw-att"
  }
}

resource "aws_ec2_transit_gateway_route" "igw" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_attachments.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}