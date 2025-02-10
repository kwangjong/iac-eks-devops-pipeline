module "dev" {
  source = "../modules/vm"

  instances = {
    "dev-pub-mgmt-vm-a" = {
        instance_type = "t2.micro"
        subnet_id     = module.dev_vpc.public_subnet_ids["dev-pub-sbn-a"]
        ami           = "ami-024ea438ab0376a47"
        key_id        = "TODO"
    }
  }
}