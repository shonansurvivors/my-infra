# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket  = "shonansurvivors-master-tfstate"
    encrypt = true
    key     = "cost.tfstate"
    profile = "master"
    region  = "ap-northeast-1"
  }
}