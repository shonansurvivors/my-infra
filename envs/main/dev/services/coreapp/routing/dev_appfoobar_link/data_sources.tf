data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["main"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Name"
    values = ["main-public*"]
  }
}

data "aws_security_group" "web" {
  name = "main-web"
}
