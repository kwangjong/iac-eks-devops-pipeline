module "mgmt_vpc" {
  source = "../modules/vpc"

  vpc = {
    name             = "mgmt-vpc"
    cidr_block       = "10.0.0.0/16"
    enable_flow_logs = false #recommended for production but disabled to save costs
  }

  public_subnet = {
    "mgmt_public_apne2a_subnet" = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "ap-northeast-2a"
    },
    "mgmt_public_apne2c_subnet" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }

  private_subnet = {
    "mgmt_private_apne2a_subnet" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-northeast-2a"
    },
    "mgmt_private_apne2c_subnet" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }

  nat_gateway = {
    "mgmt_public_apne2a_nat" = {
      public_subnet_name = "mgmt_public_apne2a_subnet"
    },
    "mgmt_public_apne2c_nat" = {
      public_subnet_name = "mgmt_public_apne2c_subnet"
    }
  }

  public_route_table = {
    "mgmt_public_route_table" = {
      public_subnet_name = [
        "mgmt_public_apne2a_subnet",
        "mgmt_public_apne2c_subnet"
      ]
    }
  }


  private_route_table = {
    "mgmt_private_apne2a_route_table" = {
      nat_gateway_name = "mgmt_public_apne2a_nat"
      private_subnet_name = [
        "mgmt_private_apne2a_subnet"
      ]
    },
    "mgmt_private_apne2c_route_table" = {
      nat_gateway_name = "mgmt_public_apne2c_nat"
      private_subnet_name = [
        "mgmt_private_apne2c_subnet"
      ]
    }
  }
}
