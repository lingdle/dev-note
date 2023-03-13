#!/bin/sh
# set fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

[ $(ps -C fcitx --no-header | wc -l) -eq 0 ] && [ -x /usr/bin/fcitx ] && (nohup fcitx >/dev/null 2>&1 &)

# Added by Toolbox App
export PATH="$PATH:/home/devops/.local/share/JetBrains/Toolbox/scripts"

[ -f "${HOME}/.jetbrains.vmoptions.sh" ] && (. ${HOME}/.jetbrains.vmoptions.sh)

# jetbrains alias
alias toolbox="mynohup jetbrains-toolbox $@"
alias idea="mynohup idea $@"
alias webs="mynohup webstorm $@"
alias grip="mynohup datagrip $@"

# wsl alias
export WSL_HOST_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
alias proxy="export http_proxy=http://$WSL_HOST_IP:7890 && export https_proxy=http://$WSL_HOST_IP:7890"
alias unproxy="unset http_proxy && unset https_proxy"
alias cproxy='echo "http_proxy=$http_proxy" && echo "https_proxy=$https_proxy"'
