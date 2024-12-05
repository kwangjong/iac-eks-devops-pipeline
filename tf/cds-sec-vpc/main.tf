resource "aws_vpc" "vpc" {
  cidr_block = "10.10.128.0/27"
  tags = {
    Name = "cds-sec-vpc"
  }
}

resource "aws_subnet" "subnets" {
  for_each = {
    "sec-sbn-comm-pub-a" = {
      cidr_block        = "10.0.128.0/27"
      availability_zone = "ap-northeast-2a"
    }
    "sec-sbn-comm-pub-c" = {
      cidr_block        = "10.0.128.32/27"
      availability_zone = "ap-northeast-2c"
    }
    "sec-sbn-comm-pri-a" = {
      cidr_block        = "10.0.128.64/27"
      availability_zone = "ap-northeast-2a"
    }
    "sec-sbn-comm-pri-c" = {
      cidr_block        = "10.0.128.96/27"
      availability_zone = "ap-northeast-2c"
    }
    "sec-sbn-ap-pri-a" = {
      cidr_block        = "10.0.128.128/27"
      availability_zone = "ap-northeast-2a"
    }
    "sec-sbn-ap-pri-c" = {
      cidr_block        = "10.0.128.160/27"
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