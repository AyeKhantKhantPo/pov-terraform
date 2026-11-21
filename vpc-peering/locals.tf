locals {
  common_tags = {
    Project = var.project_name
    Owner   = var.account_name
    Managed = "terraform"
  }

  vpcs = {
    customer = {
      name = "customer-profile-vpc"
      cidr = "10.0.0.0/16"
      region = "ap-southeast-1"
      public_subnets = [
        { name = "public-customer-subnet1", cidr = "10.0.0.0/20", az = "ap-southeast-1a" },
        { name = "public-customer-subnet2", cidr = "10.0.16.0/20", az = "ap-southeast-1b" },
      ]
      private_subnets = [
        { name = "private-customer-subnet1", cidr = "10.0.32.0/20", az = "ap-southeast-1a" },
        { name = "private-customer-subnet2", cidr = "10.0.48.0/20", az = "ap-southeast-1b" },
      ]
    }

    account = {
      name = "account-vpc"
      cidr = "172.16.0.0/16"
      region = "ap-southeast-5"
      public_subnets = [
        { name = "public-account-subnet1", cidr = "172.16.0.0/20", az = "ap-southeast-5a" },
        { name = "public-account-subnet2", cidr = "172.16.48.0/20", az = "ap-southeast-5b" },
      ]
      private_subnets = [
        { name = "private-account-subnet1", cidr = "172.16.16.0/20", az = "ap-southeast-5a" },
        { name = "private-account-subnet2", cidr = "172.16.32.0/20", az = "ap-southeast-5b" },
      ]
    }

    statement = {
      name = "statement-vpc"
      cidr = "192.168.0.0/16"
      region = "ap-southeast-7"
      public_subnets = [
        { name = "public-statement-subnet1", cidr = "192.168.0.0/20", az = "ap-southeast-7a" },
        { name = "public-statement-subnet2", cidr = "192.168.48.0/20", az = "ap-southeast-7b" },
      ]
      private_subnets = [
        { name = "private-statement-subnet1", cidr = "192.168.16.0/20", az = "ap-southeast-7a" },
        { name = "private-statement-subnet2", cidr = "192.168.32.0/20", az = "ap-southeast-7b" },
      ]
    }
  }
}
