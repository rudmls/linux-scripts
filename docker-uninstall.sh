#!/bin/bash
source utils.sh

banner="
##############################
###### DOCKER UNINSTALL ######
##############################"

function remove_docker_packages() {
    declare -a packages=('docker-ce' 'docker-ce-cli' 'containerd.io')
    declare -a other_packages=$(get_packages_like "docker")
    declare -a combined_package=$(conbined_array ${packages[@]} ${other_packages[@]})
    for package in ${combined_package[@]}; do
        if is_package_exist "$package"; then
            apt-get remove --purge -y $package > /dev/null
            if [ $? ]; then echo "package $package is removed"; fi
        fi
    done
}

function remove_files() {
    declare -a files=('/var/lib/docker' '/var/run/docker' '/etc/docker')
    for file in ${files[@]}; do
        if [ -d "$file" ]; then
            rm -rf $file
            if [ $? ]; then echo "remove file : $file"; fi
        fi
    done
}

function unmount_files() {
    declare -a files=('/var/lib/docker')
    for file in ${files[@]}; do
        if is_mounted "$file"; then
            umount $file
            if [ $? ]; then echo "unmount file : $file"; fi
        fi
    done
}

function uninstall() {
    if is_user_root; then
        echo -e "$banner"
        echo -e "\n###### remove docker packages ######\n"
        remove_docker_packages
        echo -e "\n###### unmount docker files ######\n"
        unmount_files
        echo -e "\n###### remove docker files ######\n"
        remove_files
        echo -e "\n###### delete docker group ######\n"
        delete_group "docker"
    else
        echo 'The script must be run as root.' >&2
    fi
}

function main() {
    uninstall
}

main