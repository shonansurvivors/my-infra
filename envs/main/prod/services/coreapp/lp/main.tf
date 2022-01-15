resource "aws_s3_bucket" "static_files" {
  bucket = "shonansurvivors-prod-coreapp-lp"

  acl           = "public-read"
  force_destroy = false

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = {
    Name = "shonansurvivors-prod-coreapp-lp"
  }
}
