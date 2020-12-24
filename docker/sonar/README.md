# SonarQube
* Author:   Pedric Kng  
* Updated:  26 May 2020

Guide on installing SonarQube container

***
## Installation

1. Pull sonarqube container 7.9.3-community

```bash
sudo docker pull sonarqube:7.9.3-community
```

2. Create volume
```bash
sudo mkdir /data/sonarqube/
sudo chmod -R 777 /data/sonarqube/
```

3. Start Sonarqube container

```bash
sudo docker run -v /data/sonarqube/conf:/opt/sonarqube/conf \
-v /data/sonarqube/data:/opt/sonarqube/data \
-v /data/sonarqube/logs:/opt/sonarqube/logs \
-v /data/sonarqube/extensions:/opt/sonarqube/extensions \
-d --name="sonarqube" -p 9000:9000 sonarqube:7.9.3-community
```

4. Stop Sonarqube
```bash
sudo docker stop sonarqube
```

4. Restart Sonarqube
```bash
sudo docker restart sonarqube
``` 

## Quick management script 
[mySonarqube.sh](mySonarqube.sh)

## References
Atlassian Bamboo Dockerhub [[1]]  

[1]:https://hub.docker.com/r/atlassian/bamboo-server "Atlassian bamboo dockerhub"
