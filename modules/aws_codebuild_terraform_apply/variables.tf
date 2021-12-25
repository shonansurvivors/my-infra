variable "apply" {
  type = object({
    codebuild_project = object({
      name = string
      environment = object({
        environment_variable = object({
          ENV        = string
          TF_ROOT    = string
          TF_VERSION = string
        })
      })
      source = object({
        location = string
      })
    })
    iam_role = object({
      name = string
    })
    iam_policy = object({
      name = string
    })
  })
}
