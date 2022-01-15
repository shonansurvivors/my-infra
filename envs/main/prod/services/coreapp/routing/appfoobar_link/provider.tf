provider "aws" {
  profile = "prod"
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      Env       = "prod"
      System    = "main"
      ManagedBy = "my-infra"
    }
  }
}

provider "aws" {
  profile = "prod"
  alias   = "us-east-1"
  region  = "us-east-1"
}
