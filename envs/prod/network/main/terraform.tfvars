vpc_cidr = "172.16.0.0/16"

azs = {
  a = {
    public_cidr  = "172.16.0.0/20"
    private_cidr = "172.16.48.0/20"
  },
  c = {
    public_cidr  = "172.16.16.0/20"
    private_cidr = "172.16.64.0/20"
  }
}
