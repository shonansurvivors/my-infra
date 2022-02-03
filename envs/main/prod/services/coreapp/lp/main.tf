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

resource "aws_s3_bucket_public_access_block" "static_files" {
  bucket                  = aws_s3_bucket.static_files.id
  block_public_acls       = false #tfsec:ignore:aws-s3-block-public-acls
  block_public_policy     = true
  ignore_public_acls      = false #tfsec:ignore:aws-s3-ignore-public-acls
  restrict_public_buckets = true
}
