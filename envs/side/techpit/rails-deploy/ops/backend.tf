# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket  = "shonansurvivors-rails-deploy-tfstate"
    encrypt = true
    key     = "ops.tfstate"
    profile = "rails-deploy"
    region  = "ap-northeast-1"
  }
}
