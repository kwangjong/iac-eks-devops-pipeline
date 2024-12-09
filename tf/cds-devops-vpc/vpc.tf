resource "aws_vpc" "vpc" {
  cidr_block = "10.10.143.0/24"
  tags = {
    Name = "cds-devops-vpc"
  }
}

resource "aws_subnet" "subnets" {
  for_each = {
    "cds-devops-sbn-comm-pri-a" = {
      cidr_block        = "10.10.143.192/27"
      availability_zone = "ap-northeast-2a"
    }
    "cds-devops-sbn-comm-pri-c" = {
      cidr_block        = "10.10.143.224/27"
      availability_zone = "ap-northeast-2c"
    }
    "cds-devops-sbn-ap-pri-a" = {
      cidr_block        = "10.10.143.128/27"
      availability_zone = "ap-northeast-2a"
    }
    "cds-devops-sbn-ap-pri-c" = {
      cidr_block        = "10.10.143.160/27"
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

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachments" {
  transit_gateway_id = local.tgw_id
  vpc_id             = aws_vpc.vpc.id
  subnet_ids         = [
    aws_subnet.subnets["cds-devops-sbn-comm-pri-a"].id,
    aws_subnet.subnets["cds-devops-sbn-comm-pri-c"].id
  ]
  tags = {
    Name = "cds-devops-tgw-att"
  }
}