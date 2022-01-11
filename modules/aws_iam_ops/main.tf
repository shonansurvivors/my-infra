data "aws_caller_identity" "self" {}

data "aws_iam_policy_document" "saml" {
  source_json = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRoleWithSAML"
          Condition = {
            StringEquals = {
              "SAML:aud" = "https://signin.aws.amazon.com/saml"
            }
          }
          Effect = "Allow"
          Principal = {
            Federated = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:saml-provider/GoogleApps"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role" "admin" {
  name = "AdminRole"

  assume_role_policy = data.aws_iam_policy_document.saml.source_json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  max_session_duration = 14400

  tags = {
    Name = "AdminRole"
  }
}

resource "aws_iam_role" "read_only" {
  name = "ReadOnlyRole"

  assume_role_policy = data.aws_iam_policy_document.saml.source_json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
  max_session_duration = 14400

  tags = {
    Name = "ReadOnlyRole"
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = [
    "a031c46782e6e6c662c2c87c76da9aa62ccabd8e"
  ]
  url = "https://token.actions.githubusercontent.com"
}
resource "aws_iam_role" "terraform_plan" {
  name = "terraform-plan"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : aws_iam_openid_connect_provider.github.arn
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringLike" : {
              "token.actions.githubusercontent.com:sub" : "repo:shonansurvivors/infra:*"
            }
          }
        }
      ]
    }
  )
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
  max_session_duration = 3600

  tags = {
    Name = "terraform-plan"
  }
}
resource "aws_iam_role_policy" "terraform_plan_deny" {
  role = aws_iam_role.terraform_plan.id

  name = "deny"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Deny",
          "Action" : "s3:GetObject",
          "NotResource" : "arn:aws:s3:::${var.tfstate.bucket_name}/*"
        },
        {
          "Effect" : "Deny",
          "Action" : "ssm:GetParameter*",
          "Resource" : "*"
        },
        {
          "Effect" : "Deny",
          "Action" : "secretmanager:*",
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_db_instance" "test" {
  instance_class = "t1.micro"
}
