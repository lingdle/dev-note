#!/bin/bash
# Init dev env for WSL Ubuntu

set -xe

# 剔除 windows 中的命令，防止 npm 等命令污染
export PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g')

# 启用并测试代理， 需 windows 主机已启用代理在7890端口
WSL_HOST_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
export http_proxy=http://$WSL_HOST_IP:7890
export https_proxy=http://$WSL_HOST_IP:7890
curl -I https://raw.github.com

# 替换为阿里源
SOURCE_LIST_BACKUP=~/sources.list.backup
if [ ! -f "$SOURCE_LIST_BACKUP" ]; then
# 备份默认源
cp -a /etc/apt/sources.list $SOURCE_LIST_BACKUP
# 要根据自己的 sources.list 文件内容具体调整替换命令
sudo sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

# 更新系统
set +e
sudo apt update -y
sudo apt upgrade -y
# fix missing
sudo apt update --fix-missing -y
sudo apt upgrade -y
set -e
# 显示系统信息
sudo lsb_release -a

fi

# 检查并安装 git
if [ ! -x "$(command -v git)" ]; then
sudo apt install git -y
# 常用配置
# git config --global user.name "username"
# git config --global user.email "name@domain.com"

git config --global credential.helper store
git config --global core.editor vim

git config --global core.autocrlf input
git config --global core.safecrlf true

fi

# 安装zsh
if [ ! -x "$(command -v zsh)" ]; then
sudo apt install zsh -y
# 安装 oh-my-zsh : 如果安装后没有自动设置zsh为默认 terminal，则需要手动设置
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
chsh -s /bin/zsh
# 插件：命令联想提示
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 插件：命令错误检查
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# 启用插件
sed -i 's/plugins=(git)/plugins=( git zsh-autosuggestions zsh-syntax-highlighting )/g' ~/.zshrc
fi

# 安装 nvm
if [ ! -x "$(command -v nvm)" ]; then
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

NVM_CONFIG='# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'

# 追加配置 ~/.zshrc
echo "$NVM_CONFIG" >> ~/.zshrc
fi
	
# 安装 jabba 
if [ ! -x "$(command -v jabba)" ]; then
curl -fsSL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
fi

# 安装 mvn 
if [ ! -x "$(command -v mvn)" ]; then
sudo apt install maven -y
mvn -v
fi

# 安装 xfce4

if [ ! -x "$(command -v startxfce4)" ]; then

set +e
sudo apt install xfce4 -y
sudo apt update --fix-missing -y
sudo apt install xfce4 -y
set -e

# DPI 配置
echo '# xfce4 config
export DISPLAY=$WSL_HOST_IP:0.0
export QT_SCALE_FACTOR=1
export GDK_SCALE=1
export GDK_DPI_SCALE=1
export LIBGL_ALWAYS_INDIRECT=1
' >> ~/.zshrc
fi


# 安装开发工具
JET_BRAINS_HOME=/opt/jetbrains
if [ ! -d "$JET_BRAINS_HOME" ]; then
# 安装最新版 jetbrains-toolbox
cd /opt
wget https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-1.21.9547.tar.gz
sudo tar -zxvf jetbrains-toolbox-1.21.9547.tar.gz -C $JET_BRAINS_HOME

echo '# alias 配置
JET_BRAINS_HOME=/opt/jetbrains
alias toolbox="nohup $JET_BRAINS_HOME/jetbrains-toolbox-1.21.9547/jetbrains-toolbox >/dev/null 2>&1 &"
' >> ~/.zshrc
fi

if [ ! -x "$(command -v subl)" ]; then
# 安装 sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update -y
sudo apt-get install sublime-text -y
fi


