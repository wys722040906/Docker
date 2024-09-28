# 指定导出路径
export_path="/home/wys/Public/Docker"

# 导出所有镜像
mkdir -p "$export_path"
docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | while read -r line; do
    image_name=$(echo $line | awk '{print $1}')
    image_id=$(echo $line | awk '{print $2}')
    docker save -o "$export_path/${image_name//\//_}_${image_id}.tar" "$image_id"
done

# 导出所有容器
mkdir -p "$export_path"
docker ps -a --format "{{.Names}} {{.ID}}" | while read -r line; do
    container_name=$(echo $line | awk '{print $1}')
    container_id=$(echo $line | awk '{print $2}')
    docker export -o "$export_path/${container_name}_${container_id}.tar" "$container_id"
done

