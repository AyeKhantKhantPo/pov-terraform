provider "aws" {
  alias   = "customer"
  region  = "ap-southeast-1"
  profile = var.profile
}

provider "aws" {
  alias   = "account"
  region  = "ap-southeast-5"
  profile = var.profile
}

provider "aws" {
  alias   = "statement"
  region  = "ap-southeast-7"
  profile = var.profile
}

provider "tls" {}
provider "local" {}

provider "aws" {
  region  = "ap-southeast-1"
  profile = var.profile
}
