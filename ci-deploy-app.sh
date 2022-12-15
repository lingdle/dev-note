#!/bin/bash
# deploy app shell
set -e
readonly CURR_DIR=$(
  cd "$(dirname "$0")"
  pwd
)

readonly FINGER="$(date -d "${CI_COMMIT_TIMESTAMP:-$(date)}" +%Y%m%d-%H%M%S)\
-${CI_PIPELINE_ID:-PIPELINE0}\
-${CI_COMMIT_REF_SLUG:-COMMIT0}\
-${CI_COMMIT_SHORT_SHA:-SHA0}"

DEF_NODE_HOST='192.168.1.10'

OPT_BUILD_DIR='root-app/sub-app'
OPT_DEPLOY_DIR='/opt/app-home'
OPT_NODE_HOST=()
OPT_RUNNING_PARAM=('-Dspring.profiles.active=test -Dserver.port=8000')
OPT_SSH_USER='root'

#eval set -- '-h "10.1.1.1 10.1.1.2" -p "-Dspring.profiles.active=sit" -p "-D333" -d "/opt/apps-ci"'
#eval set -- '-h "10.1.1.1" -h "10.1.1.2" -p "-Dspring.profiles.active=sit" -p "-D333" -d "/opt/apps-ci"'
#eval set -- '-h "10.1.1.1" -h "10.1.1.2" -d "/opt/apps-ci"'
while getopts ":b:d:h:p:u:" option; do
  if [ -z "$OPTARG" ]; then
    continue
  fi
  case $option in
  b)
    OPT_BUILD_DIR=$OPTARG
    ;;
  d)
    OPT_DEPLOY_DIR=$OPTARG
    ;;
  h)
    OPT_NODE_HOST=("${OPT_NODE_HOST[@]}" "$OPTARG")
    ;;
  p)
    OPT_RUNNING_PARAM=("${OPT_RUNNING_PARAM[@]}" "$OPTARG")
    ;;
  u)
    OPT_SSH_USER=$OPTARG
    ;;
  *)
    echo "Options is:"
    echo "  -b :build dir"
    echo "  -d :deploy dir"
    echo "  -h :node host"
    echo "  -p :running param"
    echo "  -u :ssh user"
    ;;
  esac
done

function toOptionSet() {
  local -a params
  local -A map
  local -a tmp_arr
  local -a tmp_set
  read -ra params <<<"$*"
  for param in "${params[@]}"; do
    IFS='=' read -ra tmp_arr <<<"$param"
    if [[ ${#tmp_arr[@]} == 2 && -n "${tmp_arr[0]}" && -n "${tmp_arr[1]}" ]]; then
      map[${tmp_arr[0]}]=${tmp_arr[1]}
    fi
  done
  for key in ${!map[*]}; do
    tmp_set=("${tmp_set[@]}" "$key=${map[$key]}")
  done
  echo "${tmp_set[*]}"
}

function filterValidity() {
  echo "Filter validity options:"
  echo "  OPT_NODE_HOST:=>${#OPT_NODE_HOST[@]}:${OPT_NODE_HOST[*]}"
  if [ ${#OPT_NODE_HOST[@]} == 0 ]; then
    OPT_NODE_HOST=("$DEF_NODE_HOST")
  fi
  echo "  OPT_NODE_HOST<=:${#OPT_NODE_HOST[@]}:${OPT_NODE_HOST[*]}"

  echo "  OPT_RUNNING_PARAM:=>${#OPT_RUNNING_PARAM[@]}:${OPT_RUNNING_PARAM[*]}"
  read -ra OPT_RUNNING_PARAM <<<"$(toOptionSet "${OPT_RUNNING_PARAM[*]}")"
  echo "  OPT_RUNNING_PARAM<=:${#OPT_RUNNING_PARAM[@]}:${OPT_RUNNING_PARAM[*]}"

}

function deploy() {
  echo "Deploy source ..."
  local buildConfigFile="$CURR_DIR/../$OPT_BUILD_DIR/../pom.xml"
  local buildProjects='yto-certification-api'
  local sourceFileName='yto-certification-api-1.0.0-SNAPSHOT.jar'
  local deployFileName="deploy-$FINGER-$sourceFileName"
  local sourceFile="$CURR_DIR/../$OPT_BUILD_DIR/target/$sourceFileName"
  local runningFile="restart-app.sh"

  echo "  build app with config[$buildConfigFile]"
  mvn -U -am -f "$buildConfigFile" -pl "$buildProjects" clean package
  for host in ${OPT_NODE_HOST[*]}; do
    echo "  upload source to [$host]"
    echo "    upload sourceFile [$deployFileName]"
    ssh "$OPT_SSH_USER@$host" 'mkdir -p '"$OPT_DEPLOY_DIR"''
    scp "$sourceFile" "$OPT_SSH_USER@$host:$OPT_DEPLOY_DIR/$deployFileName"

    echo "    upload runningFile [$runningFile]"
    scp "$CURR_DIR/$runningFile" "$OPT_SSH_USER@$host:$OPT_DEPLOY_DIR"

    echo "    override runningFile with param[${OPT_RUNNING_PARAM[*]}]"
    ssh "$OPT_SSH_USER@$host" "sed -i 's/-Dspring.profiles.active=dev/""${OPT_RUNNING_PARAM[*]}""/' $OPT_DEPLOY_DIR/$runningFile"

    echo "    copy sourceFile [$sourceFileName]..."
    ssh "$OPT_SSH_USER@$host" "cp -a ""$OPT_DEPLOY_DIR/$deployFileName"" ""$OPT_DEPLOY_DIR/$sourceFileName"""
    echo "    restart app..."
    ssh "$OPT_SSH_USER@$host" ''"$OPT_DEPLOY_DIR/$runningFile"''
  done
}

echo "Deploy app ..."
filterValidity
deploy
echo "Deploy done."
