#!/bin/bash

set -o errexit
set -o xtrace

# get the user and group IDs
uid=`id -u`
gid=`id -g`
echo "Using UID: $uid and GID: $gid"

IMAGE_NAME=px4_ros2_humble
docker build --network host \
            --build-arg USER_ID=$uid \
            --build-arg GROUP_ID=$gid \
            -t $IMAGE_NAME \
             -f Dockerfile .
