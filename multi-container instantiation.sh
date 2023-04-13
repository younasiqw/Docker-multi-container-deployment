#!/bin/bash

generate_random_name() {
    echo $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
}

create_containers() {
    read -p "輸入要創建的容器數量: " num_containers
    read -p "輸入要使用的 Docker 映像名稱: " image_name
    
    for ((i=1; i<=$num_containers; i++)); do
        container_name=$(generate_random_name)
        docker run -d --name $container_name $image_name
        echo "已創建容器 $container_name 使用映像 $image_name"
    done
    echo ""
}

remove_all_containers() {
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
    echo "已暫停並刪除全部的 Docker 容器"
    echo ""
}

list_containers() {
    docker ps -a
}

stop_and_remove_container() {
    read -p "請輸入要操作的容器 ID: " container_id
    
    # 暫停容器
    docker stop $container_id
    echo "已經暫停容器 $container_id"
    
    # 刪除容器
    docker rm $container_id
    echo "已經刪除容器 $container_id"
    echo ""
}

custom_remove() {
    list_containers
    echo ""
    read -p "請輸入要操作的容器 ID: " container_id
    echo "確定要暫停並刪除容器 $container_id 嗎？（y/n）"
    read -p "> " choice
    
    if [ "$choice" == "y" ]; then
        stop_and_remove_container $container_id
    else
        echo "取消操作。"
    fi
    echo ""
}

while true; do
    echo "請選擇要執行的操作:"
    echo "1. 創建自定義數量的 Docker 容器並使用自訂的名稱和映像"
    echo "2. 暫停並刪除全部的 Docker 容器"
    echo "3. 自定義選擇要暫停並刪除的 Docker 容器"

    read -p "> " choice
    
    if [ $choice -eq 1 ]; then
        create_containers
    elif [ $choice -eq 2 ]; then
        remove_all_containers
    elif [ $choice -eq 3 ]; then
        custom_remove
    else
        echo "無效輸入，請再試一次。"
    fi
done
