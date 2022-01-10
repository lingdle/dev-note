#!/bin/bash

set -e
#set -x

SHELL_HOME=$(cd $(dirname $0); pwd)
SHELL_PARENT_HOME=$(cd $(dirname $0);cd ..; pwd)

APP_HOME_NAME='app'
APP_VERSION='1.0-SNAPSHOT'
TARGET_SERVER_SSH="root@192.168.3.110"
TARGET_SERVER_HOME="~/"
JAR_HOME="app/starter/target"
JAR_NAME="app-starter-$APP_VERSION.jar"

JAR_PATH="$SHELL_PARENT_HOME/$JAR_HOME/$JAR_NAME"


SPRING_PROFILES_ACTIVE=${1:-test}
RUN_DATE=$(date +%Y%m%d-%H%M%S)


RESTART_SHELL='
#!/bin/bash
# Restart Shell
set -e
DEPLOY_DATE=\"'$RUN_DATE'\"
RUN_DATE=\$(date +%Y%m%d-%H%M%S)
JAR_NAME=\"'$JAR_NAME'\"
JAR_LOG_NAME=\"log-\$JAR_NAME.log\"
SPRING_PROFILES_ACTIVE=\${1:-test}

CMD_JAVA_RUN=\"java -jar -Dspring.profiles.active=\$SPRING_PROFILES_ACTIVE ./\$JAR_NAME\"
CMD_NOHUP_RUN=\"nohup \$CMD_JAVA_RUN > ./\$JAR_LOG_NAME 2>&1 &\"

SHELL_HOME=\$(cd \$(dirname \$0); pwd)
cd \$SHELL_HOME

echo \"app:\$JAR_NAME deploy at \$DEPLOY_DATE\"

APP_PID=\$(ps -ef | grep \"\$JAR_NAME\" | grep -v grep | grep -v kill | awk \"{print \\\$2}\")

echo \"old app process is: \${APP_PID}...\"

if [ -n \"\${APP_PID}\" ]; then
    echo \"kill app process: \${APP_PID}...\"
    kill -9 \${APP_PID}
    sleep 2s
    echo \"app stop success.\"
else
    echo \"app already stop.\"
fi

echo \"app backup before start...\"
touch ./\$JAR_LOG_NAME
mv ./\$JAR_LOG_NAME ./old-\$RUN_DATE-\$JAR_LOG_NAME
cp -a -n ./\$JAR_NAME ./old-\$DEPLOY_DATE-\$JAR_NAME

echo \"app start...\"

echo \"\$CMD_NOHUP_RUN\"
echo \"\$CMD_NOHUP_RUN\" | bash

echo \"app start success.\"
ps -ef | grep \"\$JAR_NAME\" | grep -v grep
exit
'

CMD_BUILD_APP="cd $SHELL_PARENT_HOME && mvn clean package -Dmaven.test.skip=true"
CMD_READY_DEPLOY_DIR="mkdir -p $APP_HOME_NAME && ls"
CMD_CP_JAR="cd $APP_HOME_NAME && cp -a $JAR_PATH . && ls"
CMD_CREATE_RESTART_SHELL="echo \"$RESTART_SHELL\" > ./$APP_HOME_NAME/restart.sh"

CMD_SCP_APP_RESOURCES="scp -r $APP_HOME_NAME $TARGET_SERVER_SSH:$TARGET_SERVER_HOME"


CMD_RUN_RESTART_SHELL="sh $TARGET_SERVER_HOME/$APP_HOME_NAME/restart.sh"
CMD_REMOTE_RESTART="ssh $TARGET_SERVER_SSH '$CMD_RUN_RESTART_SHELL'"

# run command
echo "Go to $SHELL_HOME"
cd $SHELL_HOME
echo "Build App ..."
#echo "$CMD_BUILD_APP" | sh

echo "Ready Upload App ..."
echo "$CMD_READY_DEPLOY_DIR"
echo "$CMD_READY_DEPLOY_DIR" | sh

echo "$CMD_CP_JAR"
echo "$CMD_CP_JAR" | sh

#echo "$CMD_CREATE_RESTART_SHELL"
echo "$CMD_CREATE_RESTART_SHELL" | sh

echo "Start Upload App ..."
#echo "$CMD_SCP_APP_RESOURCES"
#echo "$CMD_SCP_APP_RESOURCES" | sh

echo "Remote Restart App ..."
#echo "$CMD_REMOTE_RESTART"
#echo "$CMD_REMOTE_RESTART" | sh

exit



