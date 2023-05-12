
# Centos7.6 安装 docker

```
https://docs.docker.com/install/linux/docker-ce/centos/
```

##### 执行步骤

```
准备->安装
```

## 安装前的准备
##### 卸载旧版本

``` 
sudo yum remove docker \
	docker-client \
	docker-client-latest \
	docker-common \
	docker-latest \
	docker-latest-logrotate \
	docker-logrotate \
	docker-engine
```

##### 安装依赖

```
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

##### 安装 docker-ce 镜像源

```
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

## 安装&更新&卸载
##### 安装

```
sudo yum list docker-ce
sudo yum install docker-ce docker-ce-cli containerd.io
```
##### 更新

```
yum -y upgrade
```
##### 卸载

```
sudo yum remove docker-ce
sudo rm -rf /var/lib/docker
```

## 启动&停止&自动启停

##### 启动

```
sudo systemctl start docker
```
##### 停止

```
sudo systemctl stop docker
```
##### 自动启停

```
sudo systemctl enable docker
sudo systemctl disable docker
```
## 配置镜像加速器

```
cd /etc/docker/
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://dockerhub.azk8s.cn",
    "https://reg-mirror.qiniu.com",
    "https://registry.docker-cn.com"
  ]
}
EOF
```
## 常用命令 Docker version 19.03.2, build 6a30dfc

```
sudo systemctl start docker
sudo systemctl stop docker
sudo systemctl restart docker
sudo docker run hello-world

docker search mysql
docker -v
docker info
docker image ls
docker ps -a
docker container ls --all
docker container ls -a

docker ps -a
docker exec -it mynginx /bin/bash 
```

##### 启动mysql容器

```
docker pull mysql
docker run -di --name demo_mysql -p 33306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql


docker run \
--name db-mysql \
-p 3306:3306 \
-v /root/docker-space/mysql/datadir:/var/lib/mysql \
-v /root/docker-space/mysql/conf.d:/etc/mysql/conf.d \
-e MYSQL_ROOT_PASSWORD=111111 \
-d --restart=always mysql:8.0.17


docker run --restart=always
docker update --restart=always

docker exec -it db-mysql bash
docker exec -it db-mysql mysql -uroot -p
docker logs db-mysql

```

##### 启动nuex

##### 清理docker

```
docker container ls -a
docker image ls -a
docker volume ls
docker network ls

docker system prune
docker system prune --all --force --volumes

docker container stop $(docker container ls -a -q) && docker system prune --force --volumes
docker container stop $(docker container ls -a -q) && docker system prune --all --force --volumes
```
