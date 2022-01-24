provider "aws" {
  profile = "rails-deploy"
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      Env       = "rails-deploy"
      System    = "main"
      ManagedBy = "my-infra"
    }
  }
}

provider "aws" {
  profile = "rails-deploy"
  alias   = "us-east-1"
  region  = "us-east-1"
}
