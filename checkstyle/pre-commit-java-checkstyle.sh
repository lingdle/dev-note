#!/bin/bash -e
echo "=============================="
echo "Checkstyle start..."
echo "    check file set:"
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
  java -Duser.language=zh -jar checkstyle/checkstyle-9.3-all.jar -c checkstyle/google-checkstyle.xml "${files[@]}"
  RET_CODE=$?
  echo "Errors $RET_CODE"
fi

echo "Checkstyle done..."
echo "=============================="
#exit 1
