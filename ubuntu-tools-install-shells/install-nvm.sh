# 检查并安装 nvm
if [ ! -x "$(command -v nvm)" ]; then
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

#NVM_CONFIG='# NVM configuration
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'

## 追加配置 ~/.zshrc
#echo "$NVM_CONFIG" >> ~/.zshrc
fi
