provider "aws" {
  profile = "dev"
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      Env       = "dev"
      System    = "main"
      ManagedBy = "my-infra"
    }
  }
}

provider "aws" {
  profile = "dev"
  alias   = "us-east-1"
  region  = "us-east-1"
}
