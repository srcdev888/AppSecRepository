#!/bin/bash

# 'Squid' proxy container
#docker pull sameersbn/squid:3.5.27-2

CONTAINER_NAME="mysquid"
if [[ $1 = "run" ]]
then
# '--rm' automatically removed container upon exit
        docker run --name $CONTAINER_NAME -d --restart=always \
        --publish 3128:3128 \
        --volume /srv/docker/squid/cache:/var/spool/squid \
        sameersbn/squid:3.5.27-2
elif [[ $1 = "start" ]]
then
        docker start $CONTAINER_NAME
elif [[ $1 = "stop" ]]
then
        docker stop $CONTAINER_NAME
elif [[ $1 = "rm" ]]
then
        docker rm $CONTAINER_NAME
elif [[ $1 = "tail" ]]
then
        docker exec -it -u root $CONTAINER_NAME  tail -f /var/log/squid/access.log
elif [[ $1 = "edit" ]]
then
        docker exec -it -u root $CONTAINER_NAME  nano /etc/squid/squid.conf
elif [[ $1 = "exec" ]]
then
        docker exec -it -u root $CONTAINER_NAME /bin/sh
else
        echo "./mysquid.sh <run|start|stop|rm|tail|edit|exec>"
fi