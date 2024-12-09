terraform {
  backend "s3" {
    bucket         = "cds-basics-tf-state-bucket"
    key            = "cds-prd-vpc/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

data "terraform_remote_state" "cds_sec_vpc" {
  backend = "s3"
  config = {
    bucket         = "cds-basics-tf-state-bucket"
    key            = "cds-sec-vpc/terraform.tfstate"
    region         = "ap-northeast-2"
  }
}

locals {
  tgw_id = data.terraform_remote_state.cds_sec_vpc.outputs.tgw_id
}