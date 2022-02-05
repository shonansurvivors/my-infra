#tfsec:ignore:aws-s3-enable-bucket-encryption
resource "aws_s3_bucket" "static_files" {
  bucket = "shonansurvivors-prod-coreapp-lp"

  acl           = "public-read" #tfsec:ignore:aws-s3-no-public-access-with-acl
  force_destroy = false

  lifecycle_rule {
    enabled = true
    id      = "remove-old-objects"

    abort_incomplete_multipart_upload_days = 7

    noncurrent_version_expiration {
      days = 30
    }
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  versioning {
    enabled = true
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
