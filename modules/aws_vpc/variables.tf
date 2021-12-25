variable "vpc" {
  type = object({
    cidr_block = string
    tags       = map(string)
  })
}
