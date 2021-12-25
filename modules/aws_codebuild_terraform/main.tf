resource "aws_codebuild_project" "plan" {
  # If CodeBuild projects are same name, their results are displayed as one in GitHub PR.
  name         = var.plan.codebuild_project.name
  service_role = aws_iam_role.plan.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "ENV"
      type  = "PLAINTEXT"
      value = var.plan.codebuild_project.environment.environment_variable.ENV
    }

    environment_variable {
      name  = "GITHUB_TOKEN_PATH"
      type  = "PLAINTEXT"
      value = var.plan.codebuild_project.environment.environment_variable.GITHUB_TOKEN_PATH
    }

    environment_variable {
      name  = "TF_ROOT"
      type  = "PLAINTEXT"
      value = var.plan.codebuild_project.environment.environment_variable.TF_ROOT
    }

    environment_variable {
      name  = "TF_VERSION"
      type  = "PLAINTEXT"
      value = var.plan.codebuild_project.environment.environment_variable.TF_VERSION
    }
  }

  source {
    type            = "GITHUB"
    location        = var.plan.codebuild_project.source.location
    git_clone_depth = 1
    buildspec       = "modules/aws_codebuild_terraform/buildspec.yml"
  }
}

resource "aws_codebuild_webhook" "plan" {
  project_name = aws_codebuild_project.plan.name

  filter_group {
    filter {
      exclude_matched_pattern = false
      pattern                 = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED"
      type                    = "EVENT"
    }
  }
}

resource "aws_iam_role" "plan" {
  name = var.plan.iam_role.name

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "codebuild.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    aws_iam_policy.plan.arn
  ]
}

resource "aws_iam_policy" "plan" {
  name = var.plan.iam_policy.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:log-group:/aws/codebuild/${var.plan.codebuild_project.name}",
            "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:log-group:/aws/codebuild/${var.plan.codebuild_project.name}:*"
          ],
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
        },
        {
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:s3:::codepipeline-${data.aws_region.current.id}-*"
          ],
          "Action" : [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
          ],
          "Resource" : [
            "arn:aws:codebuild:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:report-group/${var.plan.codebuild_project.name}-*"
          ]
        }
      ]
    }
  )
}
