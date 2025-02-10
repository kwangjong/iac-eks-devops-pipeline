module "dev_vpc" {
  source = "../modules/vpc"

  vpc = {
    name             = "dev-vpc"
    cidr_block       = "10.1.0.0/16"
    enable_flow_logs = false #recommended for production but disabled to save costs
  }

  public_subnet = {
    "dev-pub-sbn-a" = {
      cidr_block        = "10.1.0.0/24"
      availability_zone = "ap-northeast-2a"
    },
    "dev-pub-sbn-c" = {
      cidr_block        = "10.1.1.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }

  private_subnet = {
    "dev-pri-sbn-a" = {
      cidr_block        = "10.1.2.0/24"
      availability_zone = "ap-northeast-2a"
    },
    "dev-pri-sbn-c" = {
      cidr_block        = "10.1.3.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }

  nat_gateway = {
    "dev-pub-nat-a" = {
      public_subnet_name = "dev-pub-sbn-a"
    },
    "dev-pub-nat-c" = {
      public_subnet_name = "dev-pub-sbn-c"
    }
  }

  public_route_table = {
    "dev-pub-rt" = {
      public_subnet_name = [
        "dev-pub-sbn-a",
        "dev-pub-sbn-c"
      ]
    }
  }


  private_route_table = {
    "dev-pri-rt" = {
      nat_gateway_name = "dev-pub-nat-a"
      private_subnet_name = [
        "dev-pri-sbn-a"
      ]
    },
    "dev_private_apne2c_route_table" = {
      nat_gateway_name = "dev-pub-nat-c"
      private_subnet_name = [
        "dev-pri-sbn-c"
      ]
    }
  }
}