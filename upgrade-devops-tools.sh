#!/bin/bash
# 安装 devops 偏好工具 

set -xe
# 剔除 windows 中的命令，防止 npm 等命令污染
export PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g')

# 启用并测试代理， 需 windows 主机已启用代理在7890端口
WSL_HOST_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
export http_proxy=http://$WSL_HOST_IP:7890
export https_proxy=http://$WSL_HOST_IP:7890
curl -I https://raw.github.com

# 检查并安装 git
if [ ! -x "$(command -v git)" ]; then
sudo apt install git -y
fi

# 检查并安装 xsel
if [ ! -x "$(command -v xsel)" ]; then
sudo apt install xsel -y
fi

# 检查并安装 jq
if [ ! -x "$(command -v jq)" ]; then
sudo apt install jq -y
fi

# 检查并安装 zsh
if [ ! -x "$(command -v zsh)" ]; then
sudo apt install zsh -y
## 安装 oh-my-zsh : 如果安装后没有自动设置zsh为默认 terminal，则需要手动设置
rm -rf ~/.oh-my-zsh
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
## 插件：命令联想提示
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
## 插件：命令错误检查
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
## 启用插件
sed -i 's/plugins=(git)/plugins=( git zsh-autosuggestions zsh-syntax-highlighting )/g' ~/.zshrc
## 切换系统默认 shell 为 zsh
chsh -s $(which zsh)
fi


# 检查并安装 nvm
if [ ! -x "$(command -v nvm)" ]; then
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

NVM_CONFIG='# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'

## 追加配置 ~/.zshrc
echo "$NVM_CONFIG" >> ~/.zshrc
fi


# 检查并安装 jabba
if [ ! -x "$(command -v jabba)" ]; then
curl -fsSL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
fi

# 检查并安装 mvn
if [ ! -x "$(command -v mvn)" ]; then
sudo apt install maven -y
mvn -v
fi


# 检查并安装 sublime
if [ ! -x "$(command -v subl)" ]; then
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update -y
sudo apt install sublime-text -y
fi


# 检查并安装 jetbrains-toolbox-app
JETBRAINS_TOOLBOX_HOME=/opt/jetbrains/jetbrains-toolbox/
if [ ! -f "$JETBRAINS_TOOLBOX_HOME/jetbrains-toolbox" ]; then
mkdir -p /opt/jetbrains/jetbrains-toolbox/
mkdir -p /opt/jetbrains/apps/
mkdir -p /opt/jetbrains/scripts/

sudo apt install libfuse2 -y

curl https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release | jq '.TBA[0].downloads.linux.link' | xargs -n1 wget -P /opt/jetbrains/

ls /opt/jetbrains/jetbrains-toolbox*.tar.gz | xargs -i tar -zxvf {} -C $JETBRAINS_TOOLBOX_HOME --strip-components 1

# TODO 设置环境变量
fi












