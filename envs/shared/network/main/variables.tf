variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = map(object({
    public_cidr  = string
    private_cidr = string
  }))
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}
