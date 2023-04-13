#!/bin/bash

generate_random_name() {
    echo $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
}

create_containers() {
    read -p "Enter the number of containers to create: " num_containers
    read -p "Enter the name of the Docker image to use: " image_name
    
    for ((i=1; i<=$num_containers; i++)); do
        container_name=$(generate_random_name)
        docker run -d --name $container_name $image_name
        echo "Created container $container_name with image $image_name"
    done
}

remove_all_containers() {
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
    echo "Removed all Docker containers"
}

list_containers() {
    docker ps -a
}

remove_container() {
    read -p "Enter the ID of the container to remove: " container_id
    docker rm $container_id
}

custom_remove() {
    list_containers
    remove_container
}

while true; do
    echo "Please select an option:"
    echo "1. Create multiple Docker containers with custom names and images"
    echo "2. Remove all Docker containers"
    echo "3. Custom remove selected Docker container"

    read -p "> " choice
    
    if [ $choice -eq 1 ]; then
        create_containers
    elif [ $choice -eq 2 ]; then
        remove_all_containers
    elif [ $choice -eq 3 ]; then
        custom_remove
    else
        echo "Invalid input. Please try again."
    fi
done
