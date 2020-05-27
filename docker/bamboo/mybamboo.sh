#!/bin/bash
# Start 'myBamboo' container

CONTAINER_NAME="bamboo-server"

if [ $1 = "run" ]
then
   docker run -v /data/bamboo:/var/atlassian/application-data/bamboo --name $CONTAINER_NAME --init -d -p 54663:54663 -p 8085:8085 atlassian/bamboo-server:6.10
elif [ $1 = "start" ]
then
        docker start $CONTAINER_NAME
elif [ $1 = "stop" ]
then
        docker stop $CONTAINER_NAME
elif [ $1 = "rm" ]
then
        docker rm $CONTAINER_NAME
else
        echo "./mybamboo.sh <run|start|stop|rm>"
fi
