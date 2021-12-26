remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket  = "shonansurvivors-prod-tfstate"
    key     = "${path_relative_to_include()}.tfstate"
    profile = "prod"
    region  = "ap-northeast-1"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
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
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_version = "1.1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}
EOF
}
