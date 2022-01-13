data "aws_caller_identity" "self" {}

resource "aws_budgets_budget" "monthly" {
  name = "monthly"

  budget_type       = "COST"
  limit_amount      = var.aws_budgets_budget.monthly.limit_amount
  limit_unit        = var.aws_budgets_budget.monthly.limit_unit
  time_unit         = "MONTHLY"
  time_period_start = "2021-12-01_00:00"

  cost_types {
    include_credit             = false
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = false
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }

  dynamic "notification" {
    for_each = local.aws_budgets_budget.monthly.notifications.threshold
    content {
      comparison_operator        = "GREATER_THAN"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = []
      subscriber_sns_topic_arns = [
        aws_sns_topic.budget.arn
      ]
      threshold      = notification.value
      threshold_type = "PERCENTAGE"
    }
  }
}

locals {
  aws_budgets_budget = {
    monthly = {
      notifications = {
        threshold = range(10, 101, 10)
      }
    }
  }
}

resource "aws_sns_topic" "budget" {
  name = "budget"

  policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Id" : "__default_policy_ID",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "budgets.amazonaws.com"
          },
          "Action" : "SNS:Publish",
          "Resource" : "*",
          "Condition" : {
            "ArnLike" : {
              "aws:SourceArn" : "arn:aws:budgets::${data.aws_caller_identity.self.account_id}:budget/*"
            }
          }
        }
      ]
    }
  )
}

resource "aws_ssm_parameter" "slack_channel_id" {
  name  = "/slack/channel/cost/id"
  type  = "SecureString"
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "slack_workspace_id" {
  name  = "/slack/workspace/shonansurvivors/id"
  type  = "SecureString"
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}

module "chatbot_slack_configuration_cost" {
  source  = "waveaccounting/chatbot-slack-configuration/aws"
  version = "1.1.0-alpha.3"

  configuration_name = "cost"
  guardrail_policies = [data.aws_iam_policy.guardrail_policy.arn]
  iam_role_arn       = aws_iam_role.chatbot_cost.arn
  logging_level      = "ERROR"
  slack_channel_id   = aws_ssm_parameter.slack_channel_id.value
  slack_workspace_id = aws_ssm_parameter.slack_workspace_id.value

  sns_topic_arns = [
    aws_sns_topic.budget.arn,
  ]
}

resource "aws_iam_role" "chatbot_cost" {
  name = "chatbot-cost"
  path = "/service-role/"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "chatbot.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_cloudwatch_log_group" "chatbot_cost" {
  provider = aws.us-east-1

  name = "/aws/chatbot/cost"

  retention_in_days = 7
}

data "aws_iam_policy" "guardrail_policy" {
  name = "ReadOnlyAccess"
}
