#!/bin/bash
set -euo pipefail

TARGET_DIRS=$1

mkdir -p "$TARGET_DIRS"

cat << EOF > "$TARGET_DIRS/terragrunt.hcl"
include "root" {
  path = find_in_parent_folders()
}
EOF

touch "$TARGET_DIRS/main.tf"

cd "$TARGET_DIRS" && terragrunt init
