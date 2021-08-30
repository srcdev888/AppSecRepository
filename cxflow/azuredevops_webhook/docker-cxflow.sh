#!/bin/sh -x

docker pull checkmarx/cx-flow:1.6.22
docker run --rm --env-file='./cxflow.env' --name=cx-flow --detach -p 8982:8585 checkmarx/cx-flow:1.6.22