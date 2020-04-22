# Docker
* Author:   Pedric Kng  
* Updated:  19 Feb 2020

***

## DevOps Tooling
* [Installing Jenkins container](jenkins/README.md)
* [Powershell script mailer](psmailer/README.md)


***

## Miscelleneous Docker commands

* Executing a command
```bash
sudo docker exec -it <container name> <command>  
e,g., sudo docker exec -it jenkins /bin/bash
```

* List docker volumes
```bash
 docker volume ls
```

* Inspect docker volume
```bash
 docker volume inspect <volume_name>
```

* List container
```bash
 docker container ls
```

* Inspect container
```bash
 docker container inspect <container_name>
```

* Run container with attached volume
```bash
 docker run -it -v ~/container-data:/data mcr.microsoft.com/powershell /bin/bash
```
