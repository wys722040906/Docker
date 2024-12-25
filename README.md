# Docker

# 安装
sudo gedit /etc/docker/daemon.json
/*
{
  "registry-mirrors":["https://docker.m.daocloud.io"],
  "dns": ["8.8.8.8", "8.8.4.4"],
  "ipv6": false
}
*/
sudo systemctl daemon-reload
sudo systemctl restart docker
docker pull hello-world
# 启动

- ### ros1:main

```
docker images
docker ps
xhost +local:`docker inspect --format='{{ .Config.Hostname }}' $containerId`
xhost +local:`docker inspect --format='{{ .Config.Hostname }}' ros1` #确保主机开启X11转发
ssh -X user@hostname #ssh远程登录宿主机，确保X11转发开启，X,Y服务
docker start $containerId
docker exec -it your_name /bin/bash
docker commit <container_id_or_name> <new_image_name>:<tag> #保存容器进度
docker cp <container_id_or_name>:<container_path> <host_path> #保存容器中某些文件
docker run -it myimage:v1 /bin/bash
```

```
docker run -it --rm \
    --gpus all \
    --group-add 44 \
    --device=/dev/video0 \
    --env="DISPLAY=:0" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/home/wys/Desktop/Project:/home/wys/" \
    --device=/dev/dri \
    --device=/dev/ttyUSB0 \
    --shm-size=8g \
    --env="GDK_SYNCHRONIZE=1" \
    --name ros1 \
    ros1:main \
    /bin/bash
```

```
docker run -it --rm  \   退出后自动删除容器！！！记得commit
	--gpus all \	GPU使能
	-group-add video \ 访问所有视频设备
	--device=/dev/video0 \	外接设备
    --device=/dev/video2 \ 
    --env="DISPLAY=:0" \	访问主机图形界面，x服务器
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \ 主机挂在Docker容器内部，文件共享，容器内部访问主机的 X11 UNIX 套接字，从而实现图形界面应用程序的显示和交互
    --volume="/home/wys/:/homw/wys/" 设置主机容器内存共享
    --device=/dev/dri \ 主机图形硬件
    --device=/dev/ttyUSB0  \usb驱动
	--shm-size=8g \增加docker容器共享内存
	--env="GDK_SYNCHRONIZE=1" \ 禁用MIT-SHM扩展，解决一些X Window系统错误
	--name xxx \  命名
    ros1:main \ 
    /bin/bash
```

- ### 相机显示

```
docker run -it --rm     --gpus all     --group-add video     --device=/dev/video0     --device=/dev/video2     --env="DISPLAY=:0"     --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"     --volume="/home/wys/Documents:/home/wys/Documents"     --device=/dev/dri     --shm-size=8g     --env="GDK_SYNCHRONIZE=1"     --name ros1     ros1:main     /bin/bash
```

```
docker run -it \
    --device=/dev/video0 \	外接设备
    --device=/dev/video2 \ 
    --env="DISPLAY" \	访问主机图形界面，x服务器
    --env "ENV_VAR_NAME=value"
    -e "ENV_VAR_NAME=value"  
    -v /host/data:/container/data
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \ 主机挂在Docker容器内部，文件共享，容器内部访问主机的 X11 UNIX 套接字，从而实现图形界面应用程序的显示和交互
    --name ros_noetic_usb_cam_container \  命名
    ros-noetic-usb-cam 镜像id | name
```







# 导出&导出镜像容器

```
docker images # 查看当前镜像
docker ps -a # 查看当前容器
docker export <container_id> -o my_container.tar #导出容器
docker save -o my_image.tar <image_name> #导出镜像
docker save -o /home/wys/Public/ros1_anaconda3.tar ros1:anaconda3 #导出镜像
docker save -o /home/wys/Public/ros1_usb_cam.tar ros1:usb_cam #导出镜像
docker save -o /home/wys/Public/noetic-desktop-full.tar osrf/ros:noetic-desktop-full #导出镜像
docker load -i my_image.tar #恢复镜像
docker import my_container.tar #恢复容器
```

- 一键导出脚本

# 删除镜像&容器

```
docker images #查看
docker rmi -f <image_name_or_id>|<docker_name:tag>
docker image prune #删除所有未使用镜像(不含标签镜像)
docker rmi $(docker images -q) #删除所有镜像

docker ps -a #查看
docker rm -f <container_name_or_id>|<docker_name:tag>
docker container prune #删除所有已停止容器

```

# 删除Docker

```
sudo systemctl stop docker #停止服务
sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli containerd runc containerd.io#卸载包和依赖项
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce #清除残留
sudo apt-get autoclean 
sudo rm -rf /var/lib/docker #删除各种配置文件
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
sudo rm -f /etc/docker/daemon.json #docker镜像配置文件
which docker #验证
getent group docker #检查组是否存在
sudo groupdel docker #可删除
```

# 安装Docker

sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io

```
sudo apt-get update  #更新系统包
sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release  #安装依赖包 HTTPS访问
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg #添加官方GPG确保软件真实性
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null  #官方仓库添加到 APT 的源列表
sudo apt-get update #更新报索引
sudo apt-get install -y docker-ce docker-ce-cli containerd.io 
#安装Docker
(docker-compose-plugin  -- docker compose)
、、
//其他版本
apt-cache madison docker-ce
sudo apt install docker-ce=5:20.10.16~3-0~ubuntu-jammy docker-ce-cli=5:20.10.16~3-0~ubuntu-jammy containerd.io docker-compose-plugin
、、
、、
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d '"' -f 4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#Docke compose验证安装
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
、、

systemctl status docker
sudo systemctl start docker #启动服务
sudo systemctl enable docker
sudo docker run hello-world #验证
sudo usermod -aG docker $USER #添加当前组


```

# DockerCompose

**多容器依赖数据管理，多镜像构建开发环境docker-compose.yml**

**定义你的服务，包括镜像、容器名称、网络配置、卷挂载等**

```
version: '3'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
  db:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: example
```

- `web`：基于 Nginx 容器，将主机的 8080 端口映射到 Nginx 的 80 端口。

  `db`：基于 MySQL 容器，并且为它设置了 `MYSQL_ROOT_PASSWORD` 环境变量。

- **启动服务**

```
docker-compose up
```

- **管理容器**

```
docker-compose ps  #查看服务状态
docker-compose stop  #停止服务
docker-compose restart #重启服务
docker-compose down  #关闭删除所有容器

```

