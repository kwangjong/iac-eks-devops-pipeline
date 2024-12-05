terraform {
  backend "s3" {
    bucket         = "cds-basics-tf-state-bucket"
    key            = "cds-sec-vpc/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-2"
}