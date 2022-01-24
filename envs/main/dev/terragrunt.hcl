remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "shonansurvivors-dev-tfstate"
    encrypt = true
    key     = "${path_relative_to_include()}.tfstate"
    profile = "dev"
    region  = "ap-northeast-1"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
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
EOF
}

generate "version" {
  path      = "version.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("version.tf")
}
