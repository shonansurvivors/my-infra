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
