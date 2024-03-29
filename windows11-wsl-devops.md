# Windows 11 + WSL:Ubuntu 搭建 DEVOPS 环境

## 前言
1. 本文核心价值观： 仅将 Windows 系统作为图形界面， 所有的**开发工具**和**开发工作**都将运行在 WSL:Linux 系统上(本文特指：WSL:Ubuntu)
2. 如果与以上价值观不符合，无需继续阅读
3. 已知问题已解决： **【偶发现象】WSL:Ubuntu xfce4 键盘方向键和小键盘区域失效，输出为数字，可以确定是windows宿主机搜狗输入法的问题，果断卸载后装上QQ拼音输入法解决**
4. 已知问题： **jetbrains 中输入法框不跟随光标位置，一直显示在左下角，据说是 jetbrains 的 linux 版本bugs， 暂且忽略无伤大雅**
5. 本文内容在以下 Windows 版本运行通过 `cmd>systeminfo`
```
OS 名称:          Microsoft Windows 11 专业版
OS 版本:          10.0.22621 暂缺 Build 22621
OS 制造商:        Microsoft Corporation
OS 配置:          独立工作站
OS 构建类型:      Multiprocessor Free
系统制造商:       ASUS
系统型号:         System Product Name
系统类型:         x64-based PC
```

## 前置准备
1. 在 Windwos 系统启用虚拟化技术：  重点1：打开 **硬件（在BIOS中）** 虚拟化  重点2：打开 **软件（在‘启用或关闭window功能/Hyper-V功能’中）** 虚拟化
2. 在 Windwos 系统启用 WSL 功能 [参考这里](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10) `https://docs.microsoft.com/zh-cn/windows/wsl/install-win10`
3. 在 Windows 系统上安装 Windows Terminal Preview：很不错的终端集成工具 [参考这里](https://github.com/microsoft/terminal) `https://github.com/microsoft/terminal`


## 构建 devops 开发环境
1. 准备让 Ubuntu 子系统可以使用 Windows 系统上的代理安装软件：重点1：在Windows 系统 **打开网络防火墙** ；重点2：**开启外网 vpn 端口: 7890 开启 Allow LAN** ; 
2. 打开 Ubuntu 子系统命令窗口，初始化系统配置> 用户名： devops 密码：******
3. 切换 Ubuntu 子系统镜像源未 aliyun 镜像源，更新修复 Ubuntu 子系统
4. 安装 输入法 fcitx-googlepinyin [参考这里](#推荐安装输入法启用fcitx-googlepinyin)
5. 安装 浏览器 Chrome [参考这里](https://learn.microsoft.com/zh-cn/windows/wsl/tutorials/gui-apps#install-google-chrome-for-linux) 打开浏览器 `$> google-chrome`
```
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install --fix-broken -y
sudo dpkg -i google-chrome-stable_current_amd64.deb
google-chrome
```

## 【推荐】优先安装 zsh 
```
curl -fsSL https://raw.githubusercontent.com/lingdle/dev-note/master/ubuntu-tools-install-shells/install-zsh.sh | bash
chsh -s $(which zsh)
# Ctrl+D 退出终端重新登录
```

## 【推荐】安装输入法：启用fcitx-googlepinyin
```
# 安装输入法依赖
sudo apt install dbus-x11 im-config fonts-noto fcitx fcitx-googlepinyin -y

# 配置输入法：打开配置工具
fcitx-configtool

## 推荐配置
#### 添加 fcitx-googlepinyin 输入法： 找不到时，取消勾选-仅显示当前语言相关
#### 解决快捷键冲突：无法触发输入法时，请重新设置一遍快捷键- trigger input method； 推荐将其他快捷键全部 按 ESC 取消
#### 设置输入法皮肤： 高级选项中设置 skin name为 dark

# 需要以下环境变量：可能在 ~/.devops-preset.sh 里找到
# config fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
# run fcitx
[ $(ps -C fcitx --no-header | wc -l) -eq 0 ] && [ -x /usr/bin/fcitx ] && (nohup fcitx >/dev/null 2>&1 &)

```
## 【推荐】WSL 环境配置
`vim /etc/wsl.conf`
```
# Network host settings that enable the DNS server used by WSL 2. This example changes the hostname, sets generateHosts to false, preventing WSL from the default behavior of auto-generating /etc/hosts, and sets generateResolvConf to false, preventing WSL from auto-generating /etc/resolv.conf, so that you can create your own (ie. nameserver 1.1.1.1).
[network]
hostname = wsl-Ubuntu-22.04

# Set whether WSL supports interop process like launching Windows apps and adding path variables. Setting these to false will block the launch of Windows processes and block adding $PATH environment variables.
[interop]
enabled = false
appendWindowsPath = false

# Set the user when launching a distribution with WSL.
[user]
default = devops

# Set a command to run when a new WSL instance launches.
[boot]
systemd = true
```


## 其他配置 

### 安装 jetbrains toolbox app [全家桶下载](https://www.jetbrains.com/zh-cn/toolbox-app/) [破解](https://jetbra.in/s) `https://jetbra.in/s`
```
curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash
```

`vim /home/devops/.local/share/JetBrains/Toolbox/scripts/mynohup`  
`chomod +x /home/devops/.local/share/JetBrains/Toolbox/scripts/mynohup`
```
#!/bin/bash
nohup $@ >/dev/null 2>&1 &
```

### 安装 JAVA
```
curl -fsSL https://raw.githubusercontent.com/lingdle/dev-note/master/ubuntu-tools-install-shells/install-java.sh | bash
```


