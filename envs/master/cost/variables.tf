variable "aws_budgets_budget" {
  type = object({
    monthly = object({
      limit_amount = string
      limit_unit   = string
    })
  })
}
