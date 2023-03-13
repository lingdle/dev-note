#!/bin/bash -e
# 检查并安装 zsh
[ ! -x "$(command -v zsh)" ] && (sudo apt install zsh -y)

if [ ! -e ~/.oh-my-zsh ]; then
## 安装 oh-my-zsh : 如果安装后没有自动设置zsh为默认 terminal，则需要手动设置
rm -rf ~/.oh-my-zsh
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
## 插件：命令联想提示
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
## 插件：命令错误检查
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
## 启用插件
sed -i 's/plugins=(.*)/plugins=( git zsh-autosuggestions zsh-syntax-highlighting )/g' ~/.zshrc
fi

## 启用 devops 预设
[ ! -s ~/.devops-preset.sh ] && (curl --create-dirs -o  ~/.devops-preset.sh https://raw.githubusercontent.com/lingdle/dev-note/master/ubuntu-tools-install-shells/devops-preset.sh)

[ -z "$(cat ~/.zshrc | grep '# config devops preset')" ] && (sed -i '/source .*/a\# config devops preset\nsource ~/.devops-preset1.sh' ~/.zshrc)

## 切换用户默认 shell 为 zsh
[ "$SHELL" != "$(which zsh)" ] && (chsh -s $(which zsh))

echo 'Run: cat ~/.zshrc | grep source'
echo 'Run: chsh -s $(which zsh)'
echo 'and relogin'
# 参考执行命令： curl -fsSL https://raw.githubusercontent.com/lingdle/dev-note/master/ubuntu-tools-install-shells/install-zsh.sh | bash
