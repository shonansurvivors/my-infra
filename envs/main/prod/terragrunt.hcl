remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "shonansurvivors-prod-tfstate"
    encrypt = true
    key     = "${path_relative_to_include()}.tfstate"
    profile = "prod"
    region  = "ap-northeast-1"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
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
EOF
}

generate "version" {
  path      = "version.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("version.tf")
}
