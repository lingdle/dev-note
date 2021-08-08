# Windows 10 + WSL:Ubuntu 开发环境搭建

## 前言
1. 价值观： 仅将 Windows 系统作为图形界面， 所有的**开发工具**和**开发工作**都将运行在 WSL:Linux 系统上(本文特指：WSL:Ubuntu)
2. 如果与以上价值观不符合，那就无需继续阅读


## 前置准备
1. 在 Windows 系统上安装 Windows Terminal Preview：不错的终端集成工具 [参考这里](https://github.com/microsoft/terminal) `https://github.com/microsoft/terminal`
2. 在 Windows 系统上准备好梯子，并启用 LAN 模式，让 WSL 可以使用梯子稳定下载 github 上的脚本
3. 如果只想开箱即用，请直接阅读 **[开箱即用](#开箱即用)**
4. 如果关注具体构建逻辑，请继续阅读 **[WSL Ubuntu Setup](#WSL Ubuntu Setup)**

## 开箱即用


## WSL Ubuntu Setup
1. 在 window 系统控制台

```bash
wsl --install -d Ubuntu
```

2. 在 Ubuntu 控制台执行 wsl-ubuntu-dev-env-init.sh

```bash
export http_proxy=http://$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):7890 && export https_proxy=http://$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):7890
curl -fsSL https://raw.githubusercontent.com/lingdle/dev-note/master/wsl-ubuntu-dev-env-init.sh | bash
```

3. 退出并重启 terminal ，配置常用环境

```bash
# 设置 alias `vim ~/.zshrc`
alias toolbox="nohup $JetBrainsToolHome/jetbrains-toolbox >/dev/null 2>&1 &"
alias idea="nohup $JetBrainsToolHome/apps/IDEA-U/ch-0/212.4746.92/bin/idea.sh >/dev/null 2>&1 &"
alias webs="nohup $JetBrainsToolHome/apps/WebStorm/ch-0/212.4746.80/bin/webstorm.sh >/dev/null 2>&1 &"

alias proxy="export http_proxy=http://$WSL_HOST_IP:7890 && export https_proxy=http://$WSL_HOST_IP:7890"
alias unproxy="unset http_proxy && unset https_proxy"
alias cproxy='echo "http_proxy=$http_proxy" && echo "https_proxy=$https_proxy"'

# 安装最新版 nodejs
nvm install --lts
# 安装 nrm
npm install -g nrm
# 切换国内npm镜像源
nrm use taobao

# 定制 nexus 私有源
nrm add nexus http://nexus-host:port/nexus-repo
nrm use nexus

# 如果配置 mvn 私服， 则需要修改 setting.xml
mvn -X
vim ~/.m2/setting.xml

# 全局安装 npm 常用工具
npm install -g nrm
npm install -g yarn
npm install -g lerna

# 配置git
git config --global user.name "username"
git config --global user.email "name@domain.com"


# 安装jdk
# wget https://download.oracle.com/otn/java/jdk/8u301-b09/d3c52aa6bfa54d3ca74e617f18309292/jdk-8u301-linux-x64.tar.gz
# wget https://download.oracle.com/otn/java/jdk/11.0.12+8/f411702ca7704a54a79ead0c2e0942a3/jdk-11.0.12_linux-x64_bin.tar.gz
# jabba install 1.8.301-oracle=tgz+file:///home/bj/jdk-8u301-linux-x64.tar.gz
# jabba install 1.11.012-oracle=tgz+file:///home/bj/jdk-11.0.12_linux-x64_bin.tar.gz

jabba install ibm@1.8
jabba use ibm@1.8
jabba alias default ibm@1.8

java --version
```
4. 常用开发工具

- jetbrains 全家桶 [参考这里](https://www.jetbrains.com/zh-cn/toolbox-app/) `https://www.jetbrains.com/zh-cn/toolbox-app/`

    > 如何破解 [参考这里](https://zhile.io/2020/11/18/jetbrains-eval-reset-da33a93d.html) `https://zhile.io/2020/11/18/jetbrains-eval-reset-da33a93d.html`   
    > `https://plugins.zhile.io`  
    > `IDE Eval Reset`
 
    > 好用的插件
    > - AutoLink 控制台链接支持点击打开文件  

    > 检查和调优配置
    > - VM Options: `-Xms2G` `-Xmx2G` `-XX:ReservedCodeCacheSize=1G`
    > - 检查文件编码格式: UTF-8
    > - 检查 检查文件换行符: LF
    > - 检查 node.js and NPM 配置， 启用 yarn 为包管理器
    > - 检查 git 环境配置
    > - 检查 jdk 配置

- Sublime [参考这里](https://www.sublimetext.com/download) `https://www.sublimetext.com/download`
    > 好用的Sublime插件： 
    > - Terminus [参考这里](https://packagecontrol.io/packages/Terminus) `https://packagecontrol.io/packages/Terminus`
    > - Timenow [参考这里](https://packagecontrol.io/packages/Timenow) `https://packagecontrol.io/packages/Timenow`





