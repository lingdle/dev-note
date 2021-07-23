# 开发环境搭建
## Widowns 10+

### 概述
1. 安装常用开发工具： WebStorm/IDEA/Sublime
2. 定制一个好用的Linux终端： WSL:Ubuntu terminal
3. 在编辑器中配置默认终端为： WSL:Ubuntu terminal

#### 安装好用的开发工具
- jetbrains 全家桶 [参考这里](https://www.jetbrains.com/zh-cn/toolbox-app/) `https://www.jetbrains.com/zh-cn/toolbox-app/`
> 如何破解 [参考这里](https://zhile.io/2020/11/18/jetbrains-eval-reset-da33a93d.html) `https://zhile.io/2020/11/18/jetbrains-eval-reset-da33a93d.html`
- Sublime [参考这里](https://www.sublimetext.com/download) `https://www.sublimetext.com/download`
> 好用的Sublime插件： 
> 1. Terminus [参考这里](https://packagecontrol.io/packages/Terminus) `https://packagecontrol.io/packages/Terminus`
> 2. Timenow [参考这里](https://packagecontrol.io/packages/Timenow) `https://packagecontrol.io/packages/Timenow`

#### 定制一个好用的Linux终端：WSL:Ubuntu
1. 安装 WSL [参考这里](https://docs.microsoft.com/zh-cn/windows/wsl/) `https://docs.microsoft.com/zh-cn/windows/wsl/`
2. 安装 WSL:Ubuntu : 两种方式
  - 【快速开始】进入 microsoft store 搜索 WSL:Ubuntu 安装应用
  - 【定制支持】安装基于docker的自定义linux系统 [参考这里](https://docs.microsoft.com/zh-cn/windows/wsl/use-custom-distro) `https://docs.microsoft.com/zh-cn/windows/wsl/use-custom-distro`
4. 定制自己 WSL:Ubuntu 环境 : 进入 WSL:Ubuntu terminal
  1. 更换阿里镜像源 [参考这里](https://developer.aliyun.com/mirror/ubuntu?spm=a2c6h.13651102.0.0.3e221b11OY2pW1) `https://developer.aliyun.com/mirror/ubuntu?spm=a2c6h.13651102.0.0.3e221b11OY2pW1`
  ```bash
  // 先核对版本
  sudo lsb_release -a
  // 备份默认源
  cp -a /etc/apt/sources.list ~/sources.list.backup
  // 替换为阿里源：要根据自己的 sources.list 文件内容具体调整替换命令
  sudo sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
  sudo sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
  
  // 更新系统
  sudo apt update -y
  sudo apt upgrade -y
  
  // 再次核对版本
  sudo lsb_release -a
  ```
  > 后续安装过程依赖 git 先确认 git 版本 : Ubuntu默认是安装过的
  ```bash
  git --version
  // 有时候 github 拉取代码网络超时， 需要尝试以下命令
  git config --global http.proxy
  git config --global https.proxy
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  ```
  2. 定制 zsh + oh-my-zsh terminal [参考这里](https://github.com/ohmyzsh/ohmyzsh/wiki) `https://github.com/ohmyzsh/ohmyzsh/wiki`
  ```
  // 安装 zsh
  sudo apt install zsh
  // 安装 oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```
  > 好用的 oh my zsh 插件
  > - 命令联想提示
  ```
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  // vim ~/.zshrc 追加插件
  plugins=( [plugins...] zsh-autosuggestions)
  ```
  > - 命令错误检查
  ```
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  // vim ~/.zshrc 追加插件
  plugins=( [plugins...] zsh-syntax-highlighting)
  ```
  3. 定制 node 环境： [参考这里](https://github.com/nvm-sh/nvm) `https://github.com/nvm-sh/nvm`
  ```
  // 安装nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
  // 核对版本
  nvm -v
  // 查看已安装 node
  nvm ls
  // 安装最新版 node
  nvm install --lts
  // 核对安装
  nvm ls
  node -v
  npm -v
  // 设为默认node 版本： nvm alias default node
  
  // 安装 nrm
  npm install -g nrm
  // 核对安装
  nrm -V
  nrm ls
  // 切换国内npm镜像源
  nrm use taobao
  ```
  > 可能需要配置 ~/.zshrc
  ```bash
  echo '# NVM configuration
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc
  ```
