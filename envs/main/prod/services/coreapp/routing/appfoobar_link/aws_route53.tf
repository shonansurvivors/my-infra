resource "aws_route53_zone" "this" {
  name = "appfoobar.link"

  force_destroy = false
}

resource "aws_route53_record" "dev_ns" {
  name    = "dev.${aws_route53_zone.this.name}"
  type    = "NS"
  zone_id = aws_route53_zone.this.id

  records = [
    "ns-1012.awsdns-62.net",
    "ns-1468.awsdns-55.org",
    "ns-1830.awsdns-36.co.uk",
    "ns-411.awsdns-51.com",
  ]
}
