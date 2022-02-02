resource "aws_lb" "this" {
  name = "main-dev-appfoobar-link"

  internal           = false
  load_balancer_type = "application"

  drop_invalid_header_fields = true

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
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

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

resource "aws_lb_listener_rule" "foo" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "aws_lb_listener_rule.foo"
      status_code  = "200"
    }
  }

  condition {
    host_header {
      values = ["foo.dev.appfoobar.link"]
    }
  }
}

resource "aws_lb_listener_rule" "bar" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "aws_lb_listener_rule.bar"
      status_code  = "200"
    }
  }

  condition {
    host_header {
      values = ["bar.dev.appfoobar.link"]
    }
  }
}
