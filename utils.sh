#!/bin/bash

# constants

user_list=`awk -F: '{print $1}' /etc/passwd`

env_list=`env | awk -F= '{print $1}'`

# functions

function conbined_array() {
    echo `echo "$@" | tr ' ' '\n' | sort -u`
}

function is_mounted() {
    [ ! -z `mount | awk '{print $3}' | grep ^$1$` ]
}

function is_package_exist() {
    [ ! -z `dpkg -l | awk '{print $2}' | grep ^$1$` ]
}

function get_packages_like() {
    echo `dpkg -l | awk '{print $2}' | grep $1`
}

function is_user_root() { 
    [ "$(id -u)" -eq 0 ]
}

function delete_group() {
    if [ $(getent group $1) ]; then
        groupdel $1
    fi
}