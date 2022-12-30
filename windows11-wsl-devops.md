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
4. 安装 输入法 fcitx-googlepinyin [参考这里](#启用fcitx-googlepinyin)
5. 安装 浏览器 Chrome [参考这里](https://learn.microsoft.com/zh-cn/windows/wsl/tutorials/gui-apps#install-google-chrome-for-linux) 打开浏览器 `$> google-chrome`
6. 安装 devops 偏好工具
7. 安装 jetbrains toolbox app [全家桶下载](https://www.jetbrains.com/zh-cn/toolbox-app/) [破解](https://jetbra.in/s)


## 启用fcitx-googlepinyin
```
sudo apt install dbus-x11 im-config fonts-noto fcitx fcitx-googlepinyin -y

# vim ~/.zshrc 追加以下配置
export INPUT_METHOD=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx

alias imfcitx='nohup fcitx >/dev/null 2>&1 &'
IMFCITX_RUNNING=$(ps -C fcitx --no-header | wc -l)
[ $IMFCITX_RUNNING -eq 0 ] && [ -x /usr/bin/fcitx ] && imfcitx

# 打开配置输入法
$> fcitx-configtool
#推荐配置
## 只保留 fcitx-googlepinyin 输入法
## 解决快捷键冲突，推荐清空快捷键设置
## 切换到 dark 皮肤
```



