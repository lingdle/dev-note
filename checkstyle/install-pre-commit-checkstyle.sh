#!/bin/bash -e
readonly CURR_DIR=$(
  cd "$(dirname "$0")"
  pwd
)

readonly gitIgnoreFile="$CURR_DIR/../.gitignore"
readonly gitIgnoreItems="/checkstyle/* !/checkstyle/install-pre-commit-checkstyle.sh"

readonly checkstyleJarRepo='https://github.com/checkstyle/checkstyle/releases/download/checkstyle-9.3/checkstyle-9.3-all.jar'
readonly checkstyleJarName='checkstyle-9.3-all.jar'
readonly checkstyleJarFile="$CURR_DIR/$checkstyleJarName"

#readonly checkstyleConfigRepo='https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml'
readonly checkstyleConfigRepo='https://raw.githubusercontent.com/lingdle/dev-note/master/checkstyle/google-checkstyle-fix.xml'
readonly checkstyleConfigName='google-checkstyle.xml'
readonly checkstyleConfigFile="$CURR_DIR/$checkstyleConfigName"

readonly preCommitSourceShellRepo="https://raw.githubusercontent.com/lingdle/dev-note/master/checkstyle/pre-commit-java-checkstyle.sh"
readonly preCommitSourceShellName="pre-commit.sh"
readonly preCommitSourceShellFile="$CURR_DIR/$preCommitSourceShellName"

readonly preCommitGitShellFile="$CURR_DIR/../.git/hooks/pre-commit"

function RegxEscape() {
  printf -v var "%q" "$1"
  echo "$var"
  return
}

function checkGitIgnore() {
  echo "Check .gitignore ..."
  touch "$gitIgnoreFile"
  for item in $gitIgnoreItems; do
    if [ "$(grep -c "^$(RegxEscape "$item")$" "$gitIgnoreFile")" -ne '0' ]; then
      echo "    already ignore item: $item"
    else
      echo "    add ignore item: $item"
      echo "$item" >>"$gitIgnoreFile"
    fi
  done
}

function checkCheckstyleJar() {
  echo "Check checkstyle jar ..."
  if [ ! -f "$checkstyleJarFile" ]; then
    echo "    checkstyle jar not find: $checkstyleJarFile"
    echo "    download checkstyle jar..."
    wget "$checkstyleJarRepo" -O "$checkstyleJarFile"
    echo "    checkstyle jar readied:$checkstyleJarFile"
  else
    echo "    checkstyle jar already exist:$checkstyleJarFile"
  fi
}

function checkCheckstyleConfig() {
  echo "Check checkstyle config ..."
  if [ ! -f "$checkstyleConfigFile" ]; then
    echo "    checkstyle config not find: $checkstyleConfigFile"
    echo "    download checkstyle config..."
    wget "$checkstyleConfigRepo" -O "$checkstyleConfigFile"
    echo "    checkstyle config readied:$checkstyleConfigFile"
  else
    echo "    checkstyle config already exist:$checkstyleJarFile"
  fi
}

function checkPreCommitShell() {
  echo "Check pre-commit shell ..."
  if [ ! -f "$preCommitSourceShellFile" ]; then
    echo "    pre-commit shell not find: $preCommitSourceShellFile"
    echo "    download pre-commit shell..."
    wget "$preCommitSourceShellRepo" -O "$preCommitSourceShellFile"
    chmod u+x "$preCommitSourceShellFile"
    echo "    pre-commit shell readied:$preCommitSourceShellFile"
  else
    echo "    pre-commit shell already exist: $preCommitSourceShellFile"
  fi
}

function linkGitPreCommit() {
  echo "Link git pre-commit ..."
  if [ ! -f "$preCommitGitShellFile" ]; then
    echo "    pre-commit shell not find: $preCommitGitShellFile"
    echo "    link $preCommitSourceShellFile to $preCommitGitShellFile"
    ln -s "$preCommitSourceShellFile" "$preCommitGitShellFile"
    ls -l "$preCommitGitShellFile"
  else
    echo "    pre-commit shell already exist: $preCommitGitShellFile"
    ls -l "$preCommitGitShellFile"
    echo "    maybe need copy shell $preCommitSourceShellName append to: $preCommitGitShellFile"
    exit 1
  fi
}

function testPreCheckstyle() {
  echo "Test checkstyle at pre-commit ..."
  echo "    git commit -m 'test checkstyle' -a "
}

echo "=============================="
echo "Install checkstyle for pre-commit..."
checkGitIgnore
checkCheckstyleJar
checkCheckstyleConfig
checkPreCommitShell
linkGitPreCommit
testPreCheckstyle
echo "=============================="
#exit 1
