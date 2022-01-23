resource "aws_lb" "this" {
  name = "main-dev-appfoobar-link"

  internal           = false
  load_balancer_type = "application"

  security_groups = [
    data.aws_security_group.web.id
  ]

  subnets = data.aws_subnet_ids.public.ids

  tags = {
    Name = "main-dev-appfoobar-link"
  }
}

resource "aws_lb_listener" "https" {

  certificate_arn   = aws_acm_certificate.wild_root.arn
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "aws_lb_listener.https"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {

  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
