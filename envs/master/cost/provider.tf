# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
provider "aws" {
  profile = "master"
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      Env       = "master"
      ManagedBy = "my-infra"
    }
  }
}

provider "aws" {
  alias   = "us-east-1"
  profile = "master"
  region  = "us-east-1"

  default_tags {
    tags = {
      Env       = "master"
      ManagedBy = "my-infra"
    }
  }
}
