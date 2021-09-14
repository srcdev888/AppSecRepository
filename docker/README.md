# Docker
* Author:   Pedric Kng  
* Updated:  19 Feb 2020

***

## DevOps Tooling
* [Installing Jenkins container](jenkins/README.md)
* [Installing bamboo container](bamboo/README.md)
* [Powershell script mailer](psmailer/README.md)
* [Squid](squid/README.md)

***

## Docker commands

* Executing a command
```bash
sudo docker exec -it <container name> <command>  
e,g., sudo docker exec -it jenkins /bin/bash
```

* Executing a command as root
```bash
docker exec --user="root" -it bamboo-server /bin/bash
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

* Update container
```bash
 docker update --restart=no <container_name>
```

* Run container with name
```bash
 docker run -d --name <container name> <container repo:tag>
```

* Run container with cleanup
```bash
 docker run --rm -it <container repo:tag>
```

* Build container image
```bash
 docker build -t <username/container:tag>
```

* Run container interactively, override entrypoint
```bash
sudo docker run -it --entrypoint /bin/bash [docker_image]
```

## Dockerhub 
* Pushing image to Dockerhub registry
```bash

# tag
docker image tag <local_image>:<tag> <repo>/<remote_image>:<tag>
docker image push <repo>/<remote_image>:<tag>

```



## HyperV nested virtualization

    !!! Note that VMName containing special characters are not accepted, and features e.g., dynamic memory is not supported for nested virtualized machine. 

* Enable nested virtualization

    ```powershell
    # Get list of vm, and their name
    Get-VM

    # Set nested virtualization for VM
    Set-VMProcessor <VMName> -ExposeVirtualizationExtensions $true

    ```


## Common Troubleshooting

* Permission denied connecting to the Docker Daemon socket

    ```bash
    # Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.39/images/create?fromImage=webgoat%2Fwebgoat-8.0&tag=v8.0.0.M21: dial unix /var/run/docker.sock: connect: permission denied

    sudo chmod 666 /var/run/docker.sock
    ```

* Mounted volume not readable or writeable

    If the mounted volume is not readable/writeable in the container, it is due to the user in the container having different userid:groupid than the user on the host.

    To get around this is to start the container without the (problematic) volume mapping, then run bash on the container:

    ```bash
    docker run -p 8080:8080 -p 50000:50000 -it jenkins bin/bash
    
    id
    
    # Once inside the container's shell run the id command and you'll get results like:
    #uid=1000(jenkins) gid=1000(jenkins) groups=1000(jenkins)

    #Exit the container, go to the folder you are trying to map and run:
    chown -R 1000:1000 .

    ```

    With the permissions now matching, you should be able to run the original docker command with the volume mapping.

* Jenkins pipeline Job can't find script due to temp path @tmp....

    Issue is likely due to Jenkins host symlinks bin/sh to dash; not bash

    Adding "/bin/sh" to the "Shell Executable" option under "Manage Jenkins -> Configure System" will help to resolve it.


## References
host volume not writable [[1]]

[1]:https://stackoverflow.com/questions/44065827/jenkins-wrong-volume-permissions "host volume not writable"
[2]:https://stackoverflow.com/questions/41246161/jenkins-pipeline-job-cant-find-script-due-to-tmp-path-being-created "can't find script due to tmp oath"