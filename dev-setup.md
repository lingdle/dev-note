# 开发环境搭建
## Widowns 10+ WSL

### 概述
1. 安装常用开发工具： WebStorm/IDEA/Sublime/Windows Terminal Preview
2. 定制一个好用的Linux终端： WSL:Ubuntu terminal
3. 在编辑器中配置默认终端为： WSL:Ubuntu terminal

> **在以上配置完成后基于wsl的开发环境就搭建完成了，但是还是存在一些使用上的问题如下:**
> - 需要添加 windows 上的网络位置 `\\wsl$\Ubuntu\home\yourname\wlsworkspace` 到 windows资源管理以，方便访问linux系统内部文件
> - windows 中的 jetbrains 工具不能打开 linux 中的 symlink 符号链接， 但是 wsl Ubuntu terminal 终端命令可以识别, 这会导致 npm link 在idea中显示错误但是命令行启动是可用的
> - 在linux terminal中的文件变化，windows 中的 jetbrains 工具会找不到，原因是网络路径上的文件变化没有同步，实际文件已经存在了，只是没有刷新过来，需要等待右下角的Synchronizing file同步完成，这个过程会很漫长...

#### 安装好用的开发工具
- jetbrains 全家桶 [参考这里](https://www.jetbrains.com/zh-cn/toolbox-app/) `https://www.jetbrains.com/zh-cn/toolbox-app/`

    > 如何破解 [参考这里](https://zhile.io/2020/11/18/jetbrains-eval-reset-da33a93d.html) `https://zhile.io/2020/11/18/jetbrains-eval-reset-da33a93d.html`
    > 好用的插件
    > - AutoLink 控制台链接支持点击打开文件  

    > 简单的调优配置
    > - VM Options: `-Xms2G` `-Xmx2G` `-XX:ReservedCodeCacheSize=1G`

    > **注意：在WSL定制完成后检查以下配置（目的是仅仅在windows 环境写代码， 其他的操作都在linux环境完成）**
    > - jetbrains 工具的 terminal 应该配置为 `wsl.exe --distribution Ubuntu` ， 如果没有自动识别需要自己配置
    > - jetbrains 工具的 node.js and NPM 环境应配置为 wsl 中的 node npm 和 yarn， 如果没有自动识别需要自己 Add WSL... 显示像这样: `Ubuntu /your-node-home-path/bin/node` `yarn /usr/share/yarn`
    > - jetbrains 工具的 git 环境应该设置为 wsl 中的 git, 如果没有自动识别需呀自己配置，显示像这样: `Auto-detected: \\wsl$\Ubuntu\usr\bin\git`

- Sublime [参考这里](https://www.sublimetext.com/download) `https://www.sublimetext.com/download`
    > 好用的Sublime插件： 
    > - Terminus [参考这里](https://packagecontrol.io/packages/Terminus) `https://packagecontrol.io/packages/Terminus`
    > - Timenow [参考这里](https://packagecontrol.io/packages/Timenow) `https://packagecontrol.io/packages/Timenow`

- Windows Terminal Preview : 不错的终端集成工具 [参考这里](https://github.com/microsoft/terminal) `https://github.com/microsoft/terminal`

#### 定制一个好用的Linux终端：WSL:Ubuntu
1. 安装 WSL [参考这里](https://docs.microsoft.com/zh-cn/windows/wsl/) `https://docs.microsoft.com/zh-cn/windows/wsl/`
2. 安装 WSL:Ubuntu : 两种方式
    > - 【快速开始】进入 microsoft store 搜索 WSL:Ubuntu 安装应用
    > - 【定制支持】安装基于docker的自定义linux系统 [参考这里](https://docs.microsoft.com/zh-cn/windows/wsl/use-custom-distro) `https://docs.microsoft.com/zh-cn/windows/wsl/use-custom-distro`
3. 更换 WSL:Ubuntu 阿里镜像源 [参考这里](https://developer.aliyun.com/mirror/ubuntu?spm=a2c6h.13651102.0.0.3e221b11OY2pW1) `https://developer.aliyun.com/mirror/ubuntu?spm=a2c6h.13651102.0.0.3e221b11OY2pW1`
> 先进入 WSL:Ubuntu 
```
// 打开 windows cmd / powershell 
wsl -d Ubuntu
```
> 在 WSL:Ubuntu terminal
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
// 自己判断是否要升级git,执行以下命令
sudo apt install git
// 有时候 github 拉取代码网络超时，后续下载安装过程中，可能是需要一把梯子然后设置好代理, 主机允许 lan 连接
export http_proxy=http://your-proxy-ip:port
export https_proxy=http://your-proxy-ip:port
// 测试以下
curl -I https://raw.github.com
```

4. 定制 zsh + oh-my-zsh terminal [参考这里](https://github.com/ohmyzsh/ohmyzsh/wiki) `https://github.com/ohmyzsh/ohmyzsh/wiki`
```
// 安装 zsh 
sudo apt install zsh
// 安装 oh-my-zsh : 如果安装后没有自动设置zsh为默认 terminal，则需要手动设置: chsh -s /bin/zsh
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
// sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
> 好用的 oh my zsh 插件 一起打包了
```
// 命令联想提示
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
// 命令错误检查
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

// 启用插件
vim ~/.zshrc
plugins=( git zsh-autosuggestions zsh-syntax-highlighting )

// 设置 alias
JetBrainsToolHome="/mnt/c/Users/username/AppData/Local/JetBrains/Toolbox/apps"
alias idea="$JetBrainsToolHome/IDEA-U/ch-0/212.4746.92/bin/idea64.exe"
alias webs="$JetBrainsToolHome/WebStorm/ch-0/212.4746.80/bin/webstorm64.exe"
alias subl="/mnt/your-sublime-homepath/subl.exe"
alias proxy="export http_proxy=http://your-proxy-ip:port && export https_proxy=http://your-proxy-ip:port"
alias unproxy="unset http_proxy && unset https_proxy"
alias cproxy='echo "http_proxy=$http_proxy" && echo "https_proxy=$https_proxy"'

source ~/.zshrc
```

5. 定制 node 环境： [参考这里](https://github.com/nvm-sh/nvm) `https://github.com/nvm-sh/nvm`
```
// 安装nvm
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
// 如果用 zsh 则需要配置 ~/.zshrc
echo '# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc

source ~/.zshrc
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

// 这样使用自己的私有的nexus源
nrm add nexus http://nexus-host:port/nexus-repo
nrm use nexus

// 可选的npm 工具全局安装
npm install -g yarn
npm install -g lerna

```

6. 配置git环境

```
git config --global user.name "username"
git config --global user.email "name@domain.com"

// 将密码存做磁盘上，默认是home目录明文存贮，不安全但一劳永逸
git config --global credential.helper 'store --file <path>'

// 将密码缓存在内存中 默认900s ，15min后需要重新输入密码
git config --global credential.helper 'cache --timeout <seconds>'

// 设置 git cli 默认编辑器为 vim
git config --global core.editor vim

// 关于 git 提交文件提交时 linux/mac 和 windows 换行符不一致的设置
git config --global core.autocrlf input
git config --global core.safecrlf true

```


