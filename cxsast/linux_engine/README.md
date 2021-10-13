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
*in-works*

# Install baremetal engine on RHEL 7.9

```bash

# Register for subscription for RHEL
# https://developers.redhat.com/blog/2021/02/10/how-to-activate-your-no-cost-red-hat-enterprise-linux-subscription#
sudo subscription-manager register

# Install dotnet 3.1
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-rhel#rhel-7--net-core-31

sudo yum install scl-utils
subscription-manager repos --enable=rhel-7-server-dotnet-rpms
yum install rh-dotnet31-aspnetcore-runtime-3.1 -y

# Dotnet is not recommended to be enabled by default
scl enable rh-dotnet31 bash
# To enable dotnet permanently, add below to ~/.bashrc 
source scl_source enable rh-dotnet31

# Copy cx-engine-server tar into machine, and untar it
tar xvf cx-engine-server.tar.gz
cd cxsast-engine-server

```
There exists 2 options to run cx engine, as standalone or linux service

(i) Run as standalone, edit and execute run.sh

```sh
### run.sh ###

#!/bin/sh
#Message queue
export CX_ES_MESSAGE_QUEUE_USERNAME=cxuser
export CX_ES_MESSAGE_QUEUE_PASSWORD=message_queue_password
export CX_ES_MESSAGE_QUEUE_URL=tcp://<uri>:<port>

#AC
export CX_ES_ACCESS_CONTROL_URL=http://<uri>/CxRestAPI/auth

#End point
export CX_ES_END_POINT=127.0.0.1:8088

#TLS
export CX_ENGINE_TLS_ENABLE=false
export CX_ENGINE_CERTIFICATE_SUBJECT_NAME=certificate_subject_name
export CX_ENGINE_CERTIFICATE_PATH=certificat_path
export CX_ENGINE_CERTIFICATE_PASSWORD=certificat_password

#General
export CX_ES_LOGS_PATH=$(pwd)/logs
export CX_ES_ENGINE_WORKER_PATH=$(pwd)/engine-server
export CX_EA_ENABLED_QUEUES='ResultQueue;IncrementalFilesQueue'
export CX_ES_MESSAGE_QUEUE_DISABLE=EngineService
export CX_EA_PUBLISHING_METHOD=MessageQueue

dotnet ./EngineService.dll

```

(ii) Install cxsast engine as services

Edit file cxengine.service 

```sh
### cxengine.service ###
[Unit]
Description=Checkmarx Engine Service
After=network.target

[Service]
ExecStart=/usr/bin/dotnet /home/cxdemosg/Downloads/cxsast-engine-server/EngineService.dll
Restart=on-failure
Type=simple
Environment=CX_ES_MESSAGE_QUEUE_USERNAME=<cxuser>
Environment=CX_ES_MESSAGE_QUEUE_PASSWORD=<message_queue_password>
Environment=CX_ES_MESSAGE_QUEUE_URL=tcp://<uri>:<port>
Environment=CX_ES_ACCESS_CONTROL_URL=http://<uri>/CxRestAPI/auth
Environment=CX_ES_END_POINT=127.0.0.1:8088
Environment=CX_ES_LOGS_PATH=/<path>/checkmarx>/logs/engineService
Environment=CX_ES_ENGINE_WORKER_PATH=/<path>/checkmarx/cxsast-engine-server/engine-server
Environment=CX_ENGINE_TLS_ENABLE=false
Environment=CX_ENGINE_CERTIFICATE_SUBJECT_NAME=certificate_subject_name
Environment=CX_ENGINE_CERTIFICATE_PATH=certificat_path
Environment=CX_ENGINE_CERTIFICATE_PASSWORD=certificat_password
Environment=CX_EA_ENABLED_QUEUES=ResultQueue;IncrementalFilesQueue
Environment=CX_ES_MESSAGE_QUEUE_DISABLE=EngineService
Environment=CX_EA_PUBLISHING_METHOD=MessageQueue

[Install]
WantedBy=multi-user.target
```

Execute service installation

```bash
sudo ./install.sh
systemctl status cxengine.service
```
Verify the CxEngine server is up, version should be returned.

```bash
curl -X GET "http://<cx-engine-server>:8088/api/v1/system_information/version" -H  "accept: text/plain"
```

Configure CxSAST accordingly to register the new cx-engine.

## Common Troubleshooting
 
### Enable repository subscription manager in RHEL
```bash
#https://kerneltalks.com/howto/how-to-enable-repository-using-subscription-manager-in-rhel/

subscription-manager repos --list
subscription-manager list --available
subscription-manager attach --auto
```
### Disable RHEL Firewall
```bash
# quick disabling of firewall
systemctl status firewalld
systemctl stop firewalld

# Allow ingress port 8088 for cx-engine

``` 

### Add hostname
```bash
# Add hostname in hosts file
vi /etc/hosts
```
### Add self-signed certificate to connect to CxSAST Manager

```bash
# For RHEL 6+, follow instructions in README
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-shared-system-certificates
cat /etc/pki/ca-trust/source/README

sudo cp <cert> /etc/pki/ca-trust/source/anchors
sudo update-ca-trust

# use this command to test connection via HTTPS to CxManager
curl -v -X OPTIONS https://win-f9bg40sjd53/

```

### Dotnet not found
The dotnet path in cxsast.engine is defaulted to /usr/bin/dotnet

```bash
which dotnet 
ln -s <actual dotnet path> /usr/bin/dotnet
```


# References
Installing and Configuring the CxEngine Server on Linux (v9.3.0) [[1]]  
CxSAST Environment Variables v9.3.0 [[2]]  
"Docker memory and CPU limit [[3]]  

[1]:https://checkmarx.atlassian.net/wiki/spaces/KC/pages/2339536950/Installing+and+Configuring+the+CxEngine+Server+on+Linux+v9.3.0 "Installing and Configuring the CxEngine Server on Linux (v9.3.0)"
[2]:https://checkmarx.atlassian.net/wiki/spaces/KC/pages/2022933302/CxSAST+Environment+Variables+v9.3.0 "CxSAST Environment Variables v9.3.0"
[3]:https://phoenixnap.com/kb/docker-memory-and-cpu-limit "Docker memory and CPU limit"