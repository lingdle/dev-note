#!/bin/zsh
# Init dev env for WSL Ubuntu : 2-2

set -xe

source ~/.zshrc

# 剔除 windows 中的命令，防止 npm 等命令污染
export PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g')

# 启用并测试代理， 需 windows 主机已启用代理在7890端口
WSL_HOST_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
export http_proxy=http://$WSL_HOST_IP:7890
export https_proxy=http://$WSL_HOST_IP:7890
curl -I https://raw.github.com

# 安装最新版 nodejs
nvm install --lts

# 全局安装 npm 常用工具
npm install -g nrm
# 切换国内npm镜像源
nrm use taobao

npm install -g yarn
npm install -g lerna


# 配置 git
# git config --global user.name "username"
# git config --global user.email "name@domain.com"

git config --global credential.helper store
git config --global core.editor vim

git config --global core.autocrlf input
git config --global core.safecrlf true

# 配置 java
#jabba install ibm@1.8
#jabba use ibm@1.8
#jabba alias default ibm@1.8


# 将开发工具 移动到 /opt 下
sudo mv ~/jetbrains /opt/

# 配置 alias & display
SOME_CONFIG=$'
# alias config
WSL_HOST_IP=$(cat /etc/resolv.conf | grep nameserver | awk \'{print $2; exit;}\')
JET_BRAINS_HOME=/opt/jetbrains
JET_BRAINS_TOOLBOX=jetbrains-toolbox-1.21.9547

alias toolbox="nohup $JET_BRAINS_HOME/$JET_BRAINS_TOOLBOX/jetbrains-toolbox >/dev/null 2>&1 &"
#alias idea="nohup $JetBrainsToolHome/apps/IDEA-U/ch-0/212.4746.92/bin/idea.sh >/dev/null 2>&1 &"
#alias webs="nohup $JetBrainsToolHome/apps/WebStorm/ch-0/212.4746.80/bin/webstorm.sh >/dev/null 2>&1 &"

alias proxy="export http_proxy=http://$WSL_HOST_IP:7890 && export https_proxy=http://$WSL_HOST_IP:7890"
alias unproxy="unset http_proxy && unset https_proxy"
alias cproxy=\'echo "http_proxy=$http_proxy" && echo "https_proxy=$https_proxy"\'

# display config
export DISPLAY=$WSL_HOST_IP:0.0
export QT_SCALE_FACTOR=1
export GDK_SCALE=1
export GDK_DPI_SCALE=1
export LIBGL_ALWAYS_INDIRECT=1
'

echo "$SOME_CONFIG" >> ~/.zshrc
