data "aws_canonical_user_id" "current" {}

data "aws_cloudfront_log_delivery_canonical_user_id" "this" {}

resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "shonansurvivors-prod-cloudfront-logs"

  force_destroy = false

  grant {
    id = data.aws_canonical_user_id.current.id
    permissions = [
      "FULL_CONTROL"
    ]
    type = "CanonicalUser"
  }

  grant {
    id = data.aws_cloudfront_log_delivery_canonical_user_id.this.id
    permissions = [
      "FULL_CONTROL"
    ]
    type = "CanonicalUser"
  }

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}