terraform {
  backend "s3" {
    bucket         = "iac-eks-devops"
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-2"
}
