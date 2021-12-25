provider "aws" {
  profile = var._provider_aws_profile
  region  = var._provider_aws_region

  default_tags {
    tags = {
      Env       = var._provider_env
      ManagedBy = var._provider_repo
    }
  }
}

variable "_provider_aws_profile" {
  type = string
}

variable "_provider_aws_region" {
  type = string
}

variable "_provider_env" {
  type = string
}
variable "_provider_repo" {
  type = string
}
