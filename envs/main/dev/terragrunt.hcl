remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
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
  if_exists = "overwrite"
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
EOF
}
