data "aws_canonical_user_id" "current" {}

data "aws_cloudfront_log_delivery_canonical_user_id" "this" {}

#tfsec:ignore:aws-s3-enable-bucket-logging
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

  lifecycle_rule {
    enabled = true
    id      = "remove-old-objects"

    abort_incomplete_multipart_upload_days = 7

    expiration {
      days                         = 90
      expired_object_delete_marker = false
    }

    noncurrent_version_expiration {
      days = 30
    }
  }

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "cloudfront_logs" {
  bucket                  = aws_s3_bucket.cloudfront_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
