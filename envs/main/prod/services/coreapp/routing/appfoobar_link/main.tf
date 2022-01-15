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
