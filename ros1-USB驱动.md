# Docker-USB驱动

1. 创建Dockerfile--安装依赖项

```
# 使用ROS Noetic基础镜像
FROM ros1:latest

# 更新APT包索引，并安装必要的工具和依赖项
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    wget \
    unzip \
    python3-pip \
    ros-noetic-usb-cam \
    && rm -rf /var/lib/apt/lists/*

# 初始化ROS工作空间
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws

# 克隆usb_cam驱动源码到工作空间
RUN git clone https://github.com/ros-drivers/usb_cam.git src/usb_cam

# 编译ROS工作空间
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# 设置环境变量
RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# 启动时运行bash
CMD ["bash"]
```

2. 构建镜像

```
docker build -t ros-noetic-usb-cam .
```

3. 运行容器

```
docker run -it --device=/dev/video0 --name ros_noetic_usb_cam_container ros-noetic-usb-cam
```

4. 启动相机驱动

```
source /opt/ros/noetic/setup.bash
source /catkin_ws/devel/setup.bash
roslaunch usb_cam usb_cam-test.launch
```

5. 验证相机驱动

```
rqt_image_view
```

