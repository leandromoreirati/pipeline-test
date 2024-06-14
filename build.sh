set -eo pipefail

if [ ! -d "$PWD/built-library" ]; then
  git clone --single-branch --branch v1 https://github.com/leandromoreirati/built-library.git "$PWD/built-library"
fi

__BUILD_TOOLS_PATH="./built-library"

#__LIBRARY_PATH="./built-library"

LOG_FILE="$PWD/cluster.log"

rm -f $LOG_FILE

source "$__BUILD_TOOLS_PATH/scripts/log.sh"
source "$__BUILD_TOOLS_PATH/scripts/terraform.sh"
source "$__BUILD_TOOLS_PATH/scripts/shell_overrides.sh"

f_build_testplan() {
  terraform_testplan $ENV "$PWD/terraform" environments/$ENV.tfvars.json
}

f_build_plan() {
  terraform_plan $ENV "$PWD/terraform" $COMMIT_HASH environments/$ENV.tfvars.json
}

f_post_apply() {
  NODES=$(terraform output nodes)
  CLUSTER=$(terraform output cluster_name)
}

f_build_apply() {
  #terraform_apply $ENV "$PWD/terraform" $COMMIT_HASH f_post_apply
  terraform_apply $ENV "$PWD/terraform" $COMMIT_HASH
}

f_destroy_testplan() {
  terraform_destroy_testplan $ENV "$PWD/terraform" environments/$ENV.tfvars.json
}

f_destroy_plan() {
  terraform_destroy_plan $ENV "$PWD/terraform" $COMMIT_HASH environments/$ENV.tfvars.json
}

f_destroy_apply() {
  if [ "$ENV" == "production" ]; then
    f_log "INFO: It seems like you want to destroy a production environment. Please do it manually :-D"
    exit 1
  else
    terraform_destroy $ENV "$PWD/terraform" $COMMIT_HASH
  fi
}

f_clean() {
  rm -rfv terraform/.terraform* terraform/terraform*  terraform/tfplan*
}

case "$1" in
  testplan)
    f_build_testplan
  ;;

  plan)
    f_build_plan
  ;;

  apply)
    f_build_apply
    #f_network
    #f_cert_manager
    #f_istio
    #f_self_signed_ssl
    ##f_prometheus
    ##f_post_apply
  ;;

  deploy)
    f_build_plan
    f_build_apply
  ;;

  destroy-testplan)
    f_destroy_testplan
  ;;

  destroy-plan)
    f_destroy_plan
  ;;

  destroy-apply)
    #f_destroy_atlantis
    #f_destroy_istio
    #f_destroy_prometheus
    f_destroy_apply
  ;;

  clean)
    f_clean
  ;;

  *)
    echo "usage: build.sh plan|testplan|apply|deploy|destroy-plan|destroy-testplan|destroy-apply|clean|"
    exit 0
  ;;

esac