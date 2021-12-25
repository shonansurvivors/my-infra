terraform {
  backend "s3" {
    bucket  = "shonansurvivors-tfstate"
    key     = "my/prod/ops/sso_v1.0.3.tfstate"
    region  = "ap-northeast-1"
    profile = "prod"
  }
}
