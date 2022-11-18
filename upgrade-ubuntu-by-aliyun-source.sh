#!/bin/bash
# 使用阿里镜像源更新修复 wsl：Ubuntu

set -xe
SOURCE_LIST_BACKUP=~/sources.list.backup
if [ ! -f "$SOURCE_LIST_BACKUP" ]; then
# 备份默认源
cp -a /etc/apt/sources.list $SOURCE_LIST_BACKUP
# 要根据自己的 sources.list 文件内容具体调整替换命令
sudo sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

# 更新系统
set +e
sudo apt update -y
sudo apt upgrade -y
# fix missing
sudo apt update --fix-missing -y
sudo apt upgrade -y
set -e
# 显示系统信息
sudo lsb_release -a

fi
