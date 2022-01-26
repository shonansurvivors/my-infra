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
  profile = "master"
  alias   = "us-east-1"
  region  = "us-east-1"
}
