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
