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
