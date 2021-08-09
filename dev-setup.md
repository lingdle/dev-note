# Windows 10 + WSL:Ubuntu 开发环境搭建

## 前言
1. 价值观： 仅将 Windows 系统作为图形界面， 所有的**开发工具**和**开发工作**都将运行在 WSL:Linux 系统上(本文特指：WSL:Ubuntu)
2. 如果与以上价值观不符合，那就无需继续阅读
3. 本文内容在以下 Windows 版本运行通过 
```
版本	Windows 10 家庭中文版
版本号	20H2
安装日期	‎2021/‎7/‎30
操作系统内部版本	19042.1151
序列号	R90MSVEL
体验	Windows Feature Experience Pack 120.2212.3530.0
```


## 前置准备
1. 在 Windows 系统上安装 Windows Terminal Preview：不错的终端集成工具 [参考这里](https://github.com/microsoft/terminal) `https://github.com/microsoft/terminal`
2. 在 Windows 系统上准备好梯子，并启用 LAN 模式，让 WSL 可以使用梯子稳定下载 github 上的脚本
3. 如果只想开箱即用，请直接阅读 **[开箱即用](#开箱即用)**
4. 如果关注具体构建逻辑，请继续阅读 **[手动构建](#手动构建)**
5. 不论以上哪种方式使用，都应该在 Windows 系统安装 X Server 软件（据说Windows 11不用安装这些就可以支持 Linux GUI ,坐等升级...），本文特指 [X410](https://www.microsoft.com/zh-cn/p/x410/9nlp712zmn9q?activetab=pivot:overviewtab) `https://www.microsoft.com/zh-cn/p/x410/9nlp712zmn9q?activetab=pivot:overviewtab`

## 开箱即用
1. 下载已经手动构建好的 WSL distribution [点击下载]() `下载地址`
2. 在 Windows 系统终端执行以下命令导入 WSL 分发
```
# WSL 分发下载到 d:/wslapps/UbuntuDevPlus.tar 后导入
wsl -l -v
wsl --shutdown
wsl --unregister Ubuntu
wsl --import Ubuntu d:/wslapps/UbuntuDevPlus d:/wslapps/UbuntuDevPlus.tar --version 2
wsl -s Ubuntu
ubuntu config --default-user dev
```

3. 常用 wsl 命令备忘

```
wsl -l -v
wsl --shutdown
wsl --export Ubuntu d:/wslapps/UbuntuDevPlus.tar

```

## 手动构建
1. 在 window 系统控制台

```bash
wsl --install -d Ubuntu
```

2. 在 Ubuntu 控制台执行 wsl-ubuntu-dev-env-init.sh

- 设置代理备忘
```bash
export http_proxy=http://$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):7890
export https_proxy=http://$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):7890
```
- 执行构建脚本
```bash
export http_proxy=http://$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):7890
export https_proxy=http://$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):7890
curl -fsSL https://raw.githubusercontent.com/lingdle/dev-note/master/wsl-ubuntu-dev-env-init-2-1.sh | bash
```
- 手动启用 zsh ，执行后退出并重启 terminal
```bash
chsh -s /bin/zsh
```
- 退出并重启 terminal 后执行优化 zsh 脚本
```zsh
export http_proxy=http://$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):7890
export https_proxy=http://$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):7890
curl -fsSL https://raw.githubusercontent.com/lingdle/dev-note/master/wsl-ubuntu-dev-env-init-2-2.sh | zsh
```

3. 优化配置

```bash
# 定制 nexus 私有源
nrm add nexus http://nexus-host:port/nexus-repo
nrm use nexus

# 如果配置 mvn 私服， 则需要修改 setting.xml
mvn -X
vim ~/.m2/setting.xml

# 配置git
git config --global user.name "username"
git config --global user.email "name@domain.com"


# 安装 oracle jdk
wget https://download.oracle.com/otn/java/jdk/8u301-b09/d3c52aa6bfa54d3ca74e617f18309292/jdk-8u301-linux-x64.tar.gz
wget https://download.oracle.com/otn/java/jdk/11.0.12+8/f411702ca7704a54a79ead0c2e0942a3/jdk-11.0.12_linux-x64_bin.tar.gz
jabba install 1.8.301-oracle=tgz+file:///home/dev/jdk-8u301-linux-x64.tar.gz
jabba install 1.11.012-oracle=tgz+file:///home/dev/jdk-11.0.12_linux-x64_bin.tar.gz
jabba use 1.8.301-oracle
jabba alias default 1.8.301-oracle
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





