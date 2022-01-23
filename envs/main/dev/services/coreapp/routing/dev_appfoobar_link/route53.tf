resource "aws_route53_zone" "this" {
  name = "dev.appfoobar.link"

  force_destroy = false
}
