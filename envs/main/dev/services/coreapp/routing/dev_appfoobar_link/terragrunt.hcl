include "root" {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../../../../foundation/network/",
    "../../../../foundation/security_groups/",
  ]
}
