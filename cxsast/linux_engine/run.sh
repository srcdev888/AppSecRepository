#!/bin/bash

CX_SERVER_ENV=./server.env

docker_run_args=(
##Run container in background
-d
--user $(id -u)
##Restart policy
--restart=always
##Automatically remove the container when it exits
--rm
##Environment variable file
--env-file $CX_SERVER_ENV
##Publish a container's port to the host
-p 0.0.0.0:8088:8088
##Volume checkmarx logs directory
-v /var/checkmarx:/var/checkmarx
##Volume certificates directory (use when TLS enabled)
#-v /usr/certs:/app/certificate/
## Docker container name
--name cx-engine-server
##Checkmarx engine server image
cx-engine-server:latest
##Certificate parameters (use when TLS enabled)
#--cert_filepath /certificates_file_path/cert.pfx
#--cert_password password
)

echo deploying checkmarx engine server container
docker run "${docker_run_args[@]}"