# Windows 10 + WSL:Ubuntu 开发环境搭建

## 前言
1. 价值观： 仅将 Windows 系统作为图形界面， 所有的**开发工具**和**开发工作**都将运行在 WSL:Linux 系统上(本文特指：WSL:Ubuntu)
2. 如果与以上价值观不符合，那就无需继续阅读
3. 已知问题已解决： **【偶发现象】WSL:Ubuntu xfce4 键盘方向键和小键盘区域失效，输出为数字，可以确定是windows宿主机搜狗输入法的问题，果断卸载后装上QQ拼音输入法解决**
4. 已知问题： **jetbrains 中输入法框不跟随光标位置，一直显示在左下角，据说是 jetbrains 的 linux 版本bugs， 暂且忽略无伤大雅**
5. 本文内容在以下 Windows 版本运行通过 
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
1. 下载已经手动构建好的 WSL distribution [点击下载](https://www.aliyundrive.com/s/KVUAKLrMdT4) `https://www.aliyundrive.com/s/KVUAKLrMdT4` 8.8G+下载完成后重命名去掉.txt
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
> WLS:Ubuntu 中的预设命令

```bash
# 启动 jetbrains-toolbox
toolbox

# 启动 jetbrains-idea
idea
idea . 

# 启动 jetbrains-webstorm
webs
webs .

# 启动 sublime
subl
subl .

# 设置本地代理
proxy
unproxy
cproxy
```

3. 隐私数据设置
```
mkdir -p ~/.m2
vim ~/.m2/settings.xml
nrm add nexus http://your-nexus-repo:port/context-path
nrm use nexus
git config --global user.name "username"
git config --global user.email "name@example.com"
git config --global credential.helper store
```

> 常用 wsl 命令备忘

```
history -c
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

4. 中文输入法， 这里fcitx-sunpinyin

```
# 拼音输入法需中文语言支持，安装简体中文
sudo /etc/init.d/dbus restart
sudo xfce4-session

# 启动后进入 GUI 界面： 选择 Language Support 安装[简体中文]语言支持

# 设置启用 fcitx 输入法
im-config

# 安装完后重启系统 `wsl --shutdown`

# 添加 fcitx-sunpinyin 输入法
fcitx-configtool

# 如果 fcitx 未启动，则检查以下配置
# 配置用户 zsh :后台启动输入法 vim ~/.zshrc

alias imfcitx='nohup fcitx-autostart >/dev/null 2>&1 &'

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
imfcitx

# 让配置生效 source ~/.zshrc

# 配置输入法
citx-configtool

# 其他可用的 fcitx 输入法 
sudo apt install fcitx-googlepinyin
sudo apt install fcitx-sunpinyin
```


5. 常用开发工具

- jetbrains 全家桶 [参考这里](https://www.jetbrains.com/zh-cn/toolbox-app/) `https://www.jetbrains.com/zh-cn/toolbox-app/`

    > 如何破解 [参考这里](https://zhile.io/2020/11/18/jetbrains-eval-reset-da33a93d.html) `https://zhile.io/2020/11/18/jetbrains-eval-reset-da33a93d.html`   
    > `https://plugins.zhile.io`  
    > `IDE Eval Reset`
 
    > 好用的插件
    > - AutoLink 控制台链接支持点击打开文件  

    > 检查和调优配置
    > - VM Options: `-Xms2G` `-Xmx2G` `-XX:ReservedCodeCacheSize=1G` 大概率不需要设置： `-Drecreate.x11.input.method=true` 解决 x11 显示问题
    > - 检查文件编码格式: UTF-8
    > - 检查 检查文件换行符: LF
    > - 检查 node.js and NPM 配置， 启用 yarn 为包管理器
    > - 检查 git 环境配置
    > - 检查 jdk 配置

- Sublime [参考这里](https://www.sublimetext.com/download) `https://www.sublimetext.com/download`
    > 好用的Sublime插件： 
    > - Terminus [参考这里](https://packagecontrol.io/packages/Terminus) `https://packagecontrol.io/packages/Terminus`
    > - Timenow [参考这里](https://packagecontrol.io/packages/Timenow) `https://packagecontrol.io/packages/Timenow`





