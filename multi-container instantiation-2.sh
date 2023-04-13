#!/bin/bash

# 顯示選項菜單
echo "Select an option:"
echo "1. Create random named containers with custom quantity and image"
echo "2. Stop and remove all running containers"

# 讀取用戶輸入
read choice

case $choice in
    1)
        # 輸入要創建的容器數量和使用的映像名稱
        read -p "Enter number of containers to create: " num_containers
        read -p "Enter the Docker image name: " image_name

        # 循環創建容器
        for ((i=1;i<=num_containers;i++)); do
            # 隨機生成容器名稱
            container_name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

            # 創建容器
            docker run -d --name $container_name $image_name

            # 打印容器 ID 和名稱
            echo "Container $i created with name: $container_name and ID: $(docker ps -qf name=$container_name)"
        done
        ;;
    2)
        # 停止並刪除所有容器
        docker stop $(docker ps -aq)
        docker rm $(docker ps -aq)
        echo "All running containers have been stopped and removed."
        ;;
    *)
        echo "Invalid choice, please try again."
        ;;
esac
