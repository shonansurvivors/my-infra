resource "aws_codebuild_project" "apply" {
  name         = var.apply.codebuild_project.name
  service_role = aws_iam_role.apply.arn

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
      value = var.apply.codebuild_project.environment.environment_variable.ENV
    }

    environment_variable {
      name  = "TF_ROOT"
      type  = "PLAINTEXT"
      value = var.apply.codebuild_project.environment.environment_variable.TF_ROOT
    }

    environment_variable {
      name  = "TF_VERSION"
      type  = "PLAINTEXT"
      value = var.apply.codebuild_project.environment.environment_variable.TF_VERSION
    }
  }

  source {
    type            = "GITHUB"
    location        = var.apply.codebuild_project.source.location
    git_clone_depth = 1
    buildspec       = "modules/aws_codebuild_terraform_apply/buildspec.yml"
  }
}

resource "aws_codebuild_webhook" "apply" {
  project_name = aws_codebuild_project.apply.name

  filter_group {
    filter {
      exclude_matched_pattern = false
      pattern                 = "PUSH"
      type                    = "EVENT"
    }
    filter {
      exclude_matched_pattern = false
      pattern                 = "^refs/heads/main$"
      type                    = "HEAD_REF"
    }
  }
}

resource "aws_iam_role" "apply" {
  name = var.apply.iam_role.name

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
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}
