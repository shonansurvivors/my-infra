resource "aws_acm_certificate" "wild_root_us_east_1" {
  domain_name = "*.${aws_route53_zone.this.name}"

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.us-east-1
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.wild_root_us_east_1.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = aws_route53_zone.this.id
}

resource "aws_acm_certificate" "root_us_east_1" {
  domain_name = aws_route53_zone.this.name

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.us-east-1
}

data "aws_s3_bucket" "lp" {
  bucket = "shonansurvivors-prod-coreapp-lp"
}

data "aws_cloudfront_cache_policy" "root" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "root" {
  aliases = [
    "appfoobar.link"
  ]
  comment             = "appfoobar.link"
  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    cache_policy_id        = data.aws_cloudfront_cache_policy.root.id
    compress               = true
    target_origin_id       = data.aws_s3_bucket.lp.bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"
  }

  logging_config {
    bucket          = "shonansurvivors-prod-cloudfront-logs.s3.amazonaws.com"
    include_cookies = false
    prefix          = "appfoobar.link"
  }

  origin {
    domain_name = data.aws_s3_bucket.lp.bucket_regional_domain_name
    origin_id   = data.aws_s3_bucket.lp.bucket_regional_domain_name
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.root_us_east_1.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
