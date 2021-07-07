# CxSAST Engine
* Author:   Pedric Kng
* Updated:  30-Jun-21

This repository documents interesting articles for CxSAST Engine

## Topics
* [Install engine containers](#Install-engine-containers)
* [Deploy engine on Azure containers registry](#Deploy-engine-on-Azure-containers-registry)

***

## Install engine containers

Prequisites: 
- linux docker machine
- unzip utility
- CxSAST engine package can be found with the main release or with HF

```bash

unzip -j <engine installer>.zip

# Load engine image into registry
docker load < cx-engine-server.tar

# List cx-engine images, loaded as latest
docker images cx-engine-server

# Tag engine image with version as good practice
docker tag <image id> cx-engine-server:9.3.0.HF10

```

CxEngine configuration can be passed via environments, refer to [[2]] ;

| Env. variables      | Description | Default Value |
| ----------- | ----------- | --------- |
| CX_ES_ENGINE_WORKER_PATH  | Path to the default engine installation | /app/cxsast-engine-server/engine-server |
| CX_ES_ENGINE_SCANS_PARENT_PATH | Path to the engine and scan logs | /var/checkmarx/EngineServiceScans/ |
| CX_ES_MESSAGE_QUEUE_USERNAME | Username to authenticate to the ActiveMQ | cxuser |
| CX_ES_MESSAGE_QUEUE_PASSWORD | Token to authenticate to the Active MQ | 217070109180237009073095180245165094186241227214 |
| CX_ES_MESSAGE_QUEUE_URL | ActiveMQ URL | tcp://\<ipaddress\>:61616 |
| CX_ES_ACCESS_CONTROL_URL | Access Control URL | http://\<ipaddress\>/CxRestAPI/auth |
| CX_ES_END_POINT | Engine endpoint | \<ipaddress\>:8088 |
| CX_ENGINE_TLS_ENABLE | Enable TLS | false |
| CX_ENGINE_CERTIFICATE_SUBJECT_NAME | X509 certificate subject name | \<certificate_subject_name\> |

To execute the Checkmarx engine
```
docker run \
 -p 0.0.0.0:8088:8088 \
 -v /var/checkmarx:/var/checkmarx \
 --name cx-engine-server \
 cx-engine-server:latest

```

To push to dockerhub, see [Docker quick guide](https://github.com/cx-demo/MyAppSecRepository/blob/ea43dd7ec4069a019b1251d7a1f90f9166e83e36/docker/README.md#Dockerhub)

Sample docker engine https://hub.docker.com/r/cxdemosg/cx-engine-server


# Deploy engine on Azure containers registry
<in-works>


# References
Installing and Configuring the CxEngine Server on Linux (v9.3.0) [[1]]  
CxSAST Environment Variables v9.3.0 [[2]]  
"Docker memory and CPU limit [[3]]  

[1]:https://checkmarx.atlassian.net/wiki/spaces/KC/pages/2339536950/Installing+and+Configuring+the+CxEngine+Server+on+Linux+v9.3.0 "Installing and Configuring the CxEngine Server on Linux (v9.3.0)"
[2]:https://checkmarx.atlassian.net/wiki/spaces/KC/pages/2022933302/CxSAST+Environment+Variables+v9.3.0 "CxSAST Environment Variables v9.3.0"
[3]:https://phoenixnap.com/kb/docker-memory-and-cpu-limit "Docker memory and CPU limit"