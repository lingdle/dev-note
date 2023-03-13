#!/bin/bash

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
# 参考执行命令： curl -fsSL https://raw.githubusercontent.com/lingdle/dev-note/master/ubuntu-tools-install-shells/install-zsh.sh | bash

