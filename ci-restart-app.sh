#!/bin/bash
# restart app shell
set -e

readonly CURR_DIR=$(
  cd "$(dirname "$0")"
  pwd
)

OPT_APP_HOME=$CURR_DIR
OPT_RUNNING_PARAM=('-Dspring.profiles.active=dev')
OPT_SOURCE_FILE_NAME='some-app-admin-api-1.0.0-SNAPSHOT.jar'
OPT_TAIL_LOG='disable'

readonly RUN_DATE=$(date +%Y%m%d)
readonly running_pid_file="$CURR_DIR/runtime-$OPT_SOURCE_FILE_NAME.pid"
readonly running_log_file="$CURR_DIR/log-$RUN_DATE.log"

#eval set -- '-p "-Dspring.profiles.active=sit -Dspring.profiles.active=test -D=111 =222 = -Da -Db=" -p -Dc -p -Dd= -p -Dserver.port=8000 -d "/workspace/root-app/sub-app/target"'

while getopts ":s:p:d:l" option; do
  if [[ $option != 'l' && -z "$OPTARG" ]]; then
    continue
  fi
  case $option in
  s)
    OPT_SOURCE_FILE_NAME=$OPTARG
    ;;
  p)
    OPT_RUNNING_PARAM=("${OPT_RUNNING_PARAM[@]}" "$OPTARG")
    ;;
  d)
    OPT_APP_HOME=$OPTARG
    ;;
  l)
    OPT_TAIL_LOG='enable'
    ;;
  *)
    echo "Options is:"
    echo "  -s :source file"
    echo "  -p :running param"
    echo "  -d :app home dir"
    echo "  -l :enable tail log"
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
  echo "  OPT_RUNNING_PARAM:=>${#OPT_RUNNING_PARAM[@]}:${OPT_RUNNING_PARAM[*]}"
  read -ra OPT_RUNNING_PARAM <<<"$(toOptionSet "${OPT_RUNNING_PARAM[*]}")"
  echo "  OPT_RUNNING_PARAM<=:${#OPT_RUNNING_PARAM[@]}:${OPT_RUNNING_PARAM[*]}"
}

function stop() {
  echo "Stop application by pid ..."
  local running_pid
  touch "$running_pid_file"
  echo "  $running_pid_file is: [$(cat "$running_pid_file")]"
  running_pid=$(cat "$running_pid_file")
  echo "  running pid is: [$running_pid]"
  case $running_pid in
  [1-9][0-9]*)
    echo "  kill process: [$running_pid]..."
    if kill -0 "$running_pid"; then
      kill -9 "$running_pid"
      sleep 2s
    fi
    echo "Application stop successfully."
    ;;
  *)
    echo "Application already stop."
    ;;
  esac
}

function backup() {
  echo "Backup $CURR_DIR/log-*.log"
  mkdir -p "$CURR_DIR/bak/"
  for log in $(ls -x "$CURR_DIR/log-"*".log" || echo ''); do
    if echo "$log" | grep -v "$CURR_DIR/log-$RUN_DATE.log"; then
      mv "$log" "$CURR_DIR/bak/bak-${log##*/}"
    fi
  done
}

function start() {
  local sourceFile="$OPT_APP_HOME/$OPT_SOURCE_FILE_NAME"
  echo "Start $OPT_SOURCE_FILE_NAME use params: ${OPT_RUNNING_PARAM[*]} ..."
  if [ -f "$sourceFile" ]; then
    echo "..."
    nohup java -jar "${OPT_RUNNING_PARAM[@]}" "$sourceFile" >"$running_log_file" 2>&1 &
    echo $! >"$running_pid_file"
    echo "Application start successfully."
  else
    echo "Source file [$sourceFile] not exist."
  fi
}

function show() {
  echo "Show $OPT_SOURCE_FILE_NAME info ..."
  echo "========================"
  echo "Quick cmd:"
  echo "  netstat -ntpl"
  echo "  kill -9 $(cat "$running_pid_file")"
  echo "  tail -f $running_log_file"
  echo "  jps"
  echo "  ps -fp $(cat "$running_pid_file")"
  echo "  ps -ef | grep -v grep | grep $OPT_SOURCE_FILE_NAME"
  echo "========================"

  ps -fp "$(cat "$running_pid_file")" || echo ''

  if [ "$OPT_TAIL_LOG" == 'enable' ]; then
    echo "$OPT_TAIL_LOG"
    tail -f "$running_log_file"
  fi
}

echo "Restart app ..."
filterValidity
stop
backup
start
show
echo "Restart app done."
