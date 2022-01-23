resource "aws_route53_zone" "this" {
  name = "dev.appfoobar.link"

  force_destroy = false
}

resource "aws_route53_record" "foo_a" {
  name    = "foo.${aws_route53_zone.this.name}"
  type    = "A"
  zone_id = aws_route53_zone.this.id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
  }
}

resource "aws_route53_record" "bar_a" {
  name    = "bar.${aws_route53_zone.this.name}"
  type    = "A"
  zone_id = aws_route53_zone.this.id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
  }
}
