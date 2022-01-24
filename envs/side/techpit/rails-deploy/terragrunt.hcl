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

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("providers.tf")
}

generate "version" {
  path      = "version.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("version.tf")
}
