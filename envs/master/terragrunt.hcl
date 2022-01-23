remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "shonansurvivors-master-tfstate"
    encrypt = true
    key     = "${path_relative_to_include()}.tfstate"
    profile = "master"
    region  = "ap-northeast-1"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
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
EOF
}

generate "version" {
  path      = "version.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "1.1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}
EOF
}
