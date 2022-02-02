resource "aws_s3_bucket" "athena_query_result" {
  bucket = "shonansurvivors-prod-athena-query-result"

  acl           = "private"
  force_destroy = false

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "athena_query_result" {
  bucket                  = aws_s3_bucket.athena_query_result.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
