# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket  = "shonansurvivors-dev-tfstate"
    encrypt = true
    key     = "services/coreapp/routing/dev_appfoobar_link.tfstate"
    profile = "dev"
    region  = "ap-northeast-1"
  }
}
