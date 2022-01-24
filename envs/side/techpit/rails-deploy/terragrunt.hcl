remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "shonansurvivors-rails-deploy-tfstate"
    encrypt = true
    key     = "${path_relative_to_include()}.tfstate"
    profile = "rails-deploy"
    region  = "ap-northeast-1"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  profile = "rails-deploy"
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      Env       = "rails-deploy"
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
