#!/bin/bash -e
readonly CURR_DIR=$(
  cd "$(dirname "$0")"
  pwd
)

readonly checkstyleHome="$CURR_DIR/../../checkstyle"

readonly checkstyleJarName='checkstyle-9.3-all.jar'
readonly checkstyleJarFile="$checkstyleHome/$checkstyleJarName"

readonly checkstyleConfigName='checkstyle.xml'
readonly checkstyleConfigFile="$checkstyleHome/$checkstyleConfigName"

function checkCheckstyleJar() {
  echo "Check checkstyle jar ..."
  if [ ! -f "$checkstyleJarFile" ]; then
    echo "    checkstyle jar not find: $checkstyleJarFile"
    echo "    maybe need run ./install-pre-commit-checkstyle.sh download checkstyle jar..."
    exit 1
  else
    echo "    checkstyle jar already exist:$checkstyleJarFile"
  fi
}

function preCommitCheckstyle() {
  echo "Find uncheck file set..."
  echo "    --------------------------"
  files=()
  #for file in $(git status --porcelain | awk '{print $2}' | grep -Ev '.jar$|.sh$'); do
  #for file in $(git status --porcelain | awk '{print $2}' | grep -E '.java$|.properties$|.xml$'); do
  #for file in $(git status --porcelain | awk '{print $2}' | grep -E '.java$|.properties$'); do
  #for file in $(git status --porcelain | awk '{print $2}' | grep -E '.java$'); do
  for file in $(git status --porcelain | awk '{print $2}'); do
    if [ -f "$file" ]; then
      echo "    $file"
      files+=("$file")
    fi
  done

  echo "    --------------------------"

  if [[ ${#files[@]} -gt 0 ]]; then
    #set -x
    java -Duser.language=zh -jar "$checkstyleJarFile" -c "$checkstyleConfigFile" "${files[@]}"
    RET_CODE=$?
    echo "Errors $RET_CODE"
    if [ "$RET_CODE" -ne '0' ]; then
      echo "    need fix checkstyle"
      exit 1
    fi
    else
      echo "uncheck files is empty."
  fi
}

echo "=============================="
echo "Checkstyle start..."
checkCheckstyleJar
preCommitCheckstyle
echo "Checkstyle done..."
echo "=============================="
#exit 1
