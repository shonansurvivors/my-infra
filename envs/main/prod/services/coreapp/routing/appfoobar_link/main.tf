resource "aws_route53_zone" "this" {
  name = "appfoobar.link"

  force_destroy = false
}

resource "aws_acm_certificate" "root" {
  domain_name = aws_route53_zone.this.name

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.us-east-1
}

resource "aws_acm_certificate_validation" "root" {
  certificate_arn = aws_acm_certificate.root.arn
}

resource "aws_route53_record" "root_certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.root.domain_validation_options : dvo.domain_name => {
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

