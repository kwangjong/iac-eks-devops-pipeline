module "mgmt_vpc" {
  source = "../modules/vpc"

  vpc = {
    name       = "mgmt-vpc"
    cidr_block = "10.0.0.0/16"
  }

  public_subnets = {
    "mgmt_public_apne2a" = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "ap-northeast-2a"
    },
    "mgmt_public_apne2c" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }

  private_subnets = {
    "mgmt_private_apne2a" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-northeast-2a"
    },
    "mgmt_private_apne2c" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }

  enable_internet_gateway = true
  enable_nat_gateway      = true
}
