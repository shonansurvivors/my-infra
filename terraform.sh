#!/bin/bash
set -exo pipefail

function tf_exec() {
  env_file=$(grep -v '#' ${BASE_DIR}/.env.${ENV})
  # shellcheck disable=SC2086
  export ${env_file?}

  cp -fr "${BASE_DIR}"/_templates/_*.tf "${BASE_DIR}"/"${TARGET_DIR}"/

  cd "${BASE_DIR}"/"${TARGET_DIR}"
  terraform init \
    -backend-config "bucket=${BACKEND_BUCKET}" \
    -backend-config "key=${TARGET_DIR}".tfstate \
    -backend-config "region=${BACKEND_REGION}" \
    -backend-config "profile=${BACKEND_PROFILE}" \
    -reconfigure

  if [ -e "${ENV}.tfvars" ]; then
    TF_VAR_FILE="-var-file ${ENV}.tfvars"
  else
    TF_VAR_FILE=""
  fi

  if [ "${CODEBUILD_BUILD_ID}" ]; then
    terraform "${TF_CMD}" ${TF_VAR_FILE} ${TF_ARGS} | $(eval echo ${AFTER_TF})
  else
    terraform "${TF_CMD}" ${TF_VAR_FILE} ${TF_ARGS}
  fi
}

# Main
BASE_DIR=$(cd "$(dirname "$0")";pwd)
ENV=$1
TARGET_DIRS=$2
TF_CMD=$3
# shellcheck disable=SC2124
TF_ARGS=${@:4}

# 引数が少なければエラーにする

# -hや--helpが指定されたらヘルプを表示する

if [ "${TARGET_DIRS}" == 'ALL' ]; then
  TARGET_DIRS='.'
# else 複数ディレクトリ対応
fi

EXCLUDE_DIRS='_templates\|modules\|\.terraform'
TARGET_DIRS=$(
  cd "${BASE_DIR}"
  find ${TARGET_DIRS} -type f -name '*.tf' -exec dirname {} \; | grep -v ${EXCLUDE_DIRS} | uniq
)

for TARGET_DIR in $TARGET_DIRS; do
  tf_exec
  rm -f "${BASE_DIR}"/"${TARGET_DIR}"/_*.tf
done
