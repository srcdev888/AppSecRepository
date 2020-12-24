#!/bin/bash
# Start 'sonarqube' container

CONTAINER_NAME="sonarqube"

if [ $1 = "run" ]
then
        mkdir /data/sonarqube/
        chmod -R 777 /data/sonarqube/

        sudo docker run -v /data/sonarqube/conf:/opt/sonarqube/conf \
        -v /data/sonarqube/data:/opt/sonarqube/data \
        -v /data/sonarqube/logs:/opt/sonarqube/logs \
        -v /data/sonarqube/extensions:/opt/sonarqube/extensions \
        -d --name $CONTAINER_NAME -p 9000:9000 sonarqube:7.9.3-community

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
        echo "./myjenkins.sh <run|start|stop|rm>"
fi
