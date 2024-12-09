resource "aws_vpc" "vpc" {
  cidr_block = "10.10.129.0/24"
  tags = {
    Name = "cds-prd-vpc"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "additional_cidr_blocks" {
  for_each = toset([
    "10.10.130.0/23",
    "10.10.132.0/23"
  ])
  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value
}

resource "aws_subnet" "subnets" {
  for_each = {
    "cds-prd-sbn-comm-pri-a" = {
      cidr_block        = "10.10.129.0/27"
      availability_zone = "ap-northeast-2a"
    }
    "cds-prd-sbn-comm-pri-c" = {
      cidr_block        = "10.10.129.32/27"
      availability_zone = "ap-northeast-2c"
    }
    "cds-prd-sbn-ap-pri-a" = {
      cidr_block        = "10.10.130.0/23"
      availability_zone = "ap-northeast-2a"
      eks_subnet        = true
    }
    "cds-prd-sbn-ap-pri-c" = {
      cidr_block        = "10.10.132.0/23"
      availability_zone = "ap-northeast-2c"
      eks_subnet        = true
    }
    "cds-prd-sbn-db-pri-a" = {
      cidr_block        = "10.10.129.64/27"
      availability_zone = "ap-northeast-2a"
    }
    "cds-prd-sbn-db-pri-c" = {
      cidr_block        = "10.10.129.96/27"
      availability_zone = "ap-northeast-2c"
    }
  }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = merge(
    { Name = each.key },
    lookup(each.value, "eks_subnet", false) ? {
      "kubernetes.io/cluster/cds-prd-eks" = "shared"
      "kubernetes.io/role/internal-elb"   = "1"
    } : {}
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachments" {
  transit_gateway_id = local.tgw_id
  vpc_id             = aws_vpc.vpc.id
  subnet_ids         = [
    aws_subnet.subnets["cds-prd-sbn-comm-pri-a"].id,
    aws_subnet.subnets["cds-prd-sbn-comm-pri-c"].id
  ]
  tags = {
    Name = "cds-prd-tgw-att"
  }
}