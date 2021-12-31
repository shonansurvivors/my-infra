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

resource "aws_sns_topic_subscription" "budget_chatbot_cost" {
  confirmation_timeout_in_minutes = 1
  endpoint                        = "https://global.sns-api.chatbot.amazonaws.com"
  endpoint_auto_confirms          = false
  protocol                        = "https"
  topic_arn                       = aws_sns_topic.budget.arn
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