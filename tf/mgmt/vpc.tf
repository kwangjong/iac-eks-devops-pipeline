module "mgmt_vpc" {
  source = "../modules/vpc"

  vpc = {
    name             = "mgmt-vpc"
    cidr_block       = "10.0.0.0/16"
    enable_flow_logs = false #recommended for production but disabled to save costs
  }

  public_subnet = {
    "mgmt-pub-sbn-a" = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "ap-northeast-2a"
    },
    "mgmt-pub-sbn-c" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }

  private_subnet = {
    "mgmt-pri-sbn-a" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-northeast-2a"
    },
    "mgmt-pri-sbn-c" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }

  nat_gateway = {
    "mgmt-pub-nat-a" = {
      public_subnet_name = "mgmt-pub-sbn-a"
    },
    "mgmt-pub-nat-c" = {
      public_subnet_name = "mgmt-pub-sbn-c"
    }
  }

  public_route_table = {
    "mgmt-pub-rt" = {
      public_subnet_name = [
        "mgmt-pub-sbn-a",
        "mgmt-pub-sbn-c"
      ]
    }
  }


  private_route_table = {
    "mgmt-pri-rt" = {
      nat_gateway_name = "mgmt-pub-nat-a"
      private_subnet_name = [
        "mgmt-pri-sbn-a"
      ]
    },
    "mgmt_private_apne2c_route_table" = {
      nat_gateway_name = "mgmt-pub-nat-c"
      private_subnet_name = [
        "mgmt-pri-sbn-c"
      ]
    }
  }
}