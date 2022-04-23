#!/bin/bash
source utils.sh

banner="
##############################
####### DOCKER INSTALL #######
##############################"

function add_to_docker_group() {
    if [[ $SUDO_USER != 'root' ]]; then
        usermod -aG docker $SUDO_USER
        if [ $? ]; then 
            echo "user $SUDO_USER is add to docker group"
        fi
    fi
}

function main() {
    if is_user_root; then
        echo -e "$banner"
        echo -e "\n####### update existing package list #######\n" 
        apt update
        echo -e "\n####### install prerequisite packages #######\n" 
        apt install -y apt-transport-https ca-certificates curl software-properties-common
        echo -e "\n####### add GPC key #######\n" 
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
        echo -e "\n####### add Docker repository to APT sources #######\n" 
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
        echo -e "\n####### install docker-ce / docker-ce-cli / containerd.io #######\n" 
        sudo apt install -y docker-ce docker-ce-cli containerd.io 
        echo -e "\n####### start docker #######\n" 
        service docker start
        echo -e "\n####### add user to docker group #######\n"
        add_to_docker_group
    else
        echo 'The script must be run as root.' >&2
    fi
}

main

