# Bamboo
* Author:   Pedric Kng  
* Updated:  24 May 2020

Guide on installing Bamboo container

***
## Installation

1. Pull bamboo container 6.10

```bash
sudo docker pull atlassian/bamboo-server:6.10
```

2. Start Atlassian Bamboo

```bash

mkdir /data/bamboo
sudo chmod 777 /data/bamboo

sudo docker run -v /data/bamboo:/var/atlassian/application-data/bamboo --name="bamboo-server" --init -d -p 54663:54663 -p 8085:8085 atlassian/bamboo-server:6.10
```

3. Stop Atlassian Bamboo
```bash
sudo docker stop bamboo-server
```

4. Restart Atlassian Bamboo
```bash
sudo docker restart bamboo-server
``` 

## Quick management script 
[myBamboo.sh](myBamboo.sh)

## References
Atlassian Bamboo Dockerhub [[1]]  

[1]:https://hub.docker.com/r/atlassian/bamboo-server "Atlassian bamboo dockerhub"
