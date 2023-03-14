#!/bin/bash
# install jabba for java

# 安装 jabba 
if [ ! -x "$(command -v jabba)" ]; then
curl -fsSL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
jabba install adopt-openj9@1.8.0-262
jabba ls
jabba use adopt-openj9@1.8.0-262
jabba current
jabba alias default adopt-openj9@1.8.0-262
java -version
fi


