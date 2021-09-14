# Private repository support using CxSCA Resolver 
* Author:   Pedric Kng  
* Updated:  14-Sep-21

This article describes the usage of CxSCA Resolver to support private repository resolution

***
## Pre-requisites
- CxSCA Resolver [[1]]  
- CxSCA supported package managers [[2]]  
- Nexus OSS [[3]]  

## Setup

1. Build CxSCA Resolver Dockerfile
  
    [Dockerfile example for NPM](dockerfile)
    [Dockerfile example for Cocoapods](cocoapods/dockerfile)
    
    ```dockerfile
    # CxSCA Resolver dockerfile for NPM

    FROM alpine:latest
    
    ARG VERSION
    RUN echo ${VERSION}
    
    WORKDIR /opt/sca
    
    # Install main dependencies
    RUN apk update && \
        apk add ca-certificates && \
        apk add libstdc++ glib krb5 pcre bash && \
        apk add curl

    # Install NPM package managers
    RUN apk add npm git
    RUN npm -g install npm@6.14.12
    RUN npm install -g lerna

    RUN curl -O https://sca-downloads.s3.amazonaws.com/cli/${VERSION}/ScaResolver-musl64.tar.gz && \
        tar -xf ScaResolver-musl64.tar.gz && \
        rm -rf ScaResolver-musl64.tar.gz && \
        chmod +x ScaResolver && \
        ls -la

    ENTRYPOINT [ "./ScaResolver"]
    ```
  
    Build container

    ```bash
    # The latest version of CxSCA resolver is 1.5.45 at writing
    docker build -t cxsca-resolver-npm:1.5.45 --build-arg VERSION=1.5.45 .

    # Test if resolver is executing well
    docker run --rm cxsca-resolver-npm:1.5.45 --v

    ```

2. Execute scan

    [Sca bash example](run-sca-resolver.sh)
    ```bash
    #!/bin/sh -x

    # Execute CxSCA resolver scan

    # General
    LOG_LEVEL='--log_level Verbose'

    # CxSCA Cloud
    URL_AUTHSERVER='--authentication-server-url https://platform.checkmarx.net'
    ACCOUNT='-a <account>'
    USERNAME='-u <username>'
    PASSWORD='-p <password>'

    # Project
    PROJECT_NAME='-n <Project name>'
    ## This is hardcoded to /data in container
    SCAN_PATH='-s /data'

    # physical project directory, this should contain .npmrc to use the nexus repository
    SRC_DIR='/demos/nodegoat'

    # Fail criteria
    SEVERITY_THRESHOLD='--severity_threshold High'

    # SCA-Resolver will execute dependency check
    # npm i --package-lock-only

    # Note that we mount physical project directory to /data
    docker run --rm -v $SRC_DIR:/data  cxsca-resolver:1.5.45 $LOG_LEVEL $URL_AUTHSERVER $ACCOUNT $USERNAME $PASSWORD $PROJECT_NAME $SCAN_PATH $SEVERITY_THRESHOLD
    ```
    Execute sca scan

    ```bash
    ./run-sca-resolver.sh
    ```

## Miscellenous

- Add project-level npm credentials files '.npmrc'
    
    ```bash
    # File: .npmrc

    //192.168.137.47:8081/repository/npm.group/:_authToken=<token>
    registry = http://192.168.137.47:8081/repository/npm.group/
    email = cxdemosg@gmail.com
    ```
    * Authentication token can be generated using ***npm adduser*** command
    * Registry URL can be copied from the 'npm group repository' created in Nexus OSS. See [[4]].

- Troubleshooting when dependency resolution fails

    Many times, you might encounter error return on failed dependency resolution.
    This is usually related to the package manager installation, which SCA resolver is dependent on.
    You can refer to [[2]] for the list of dependency resolution command that is executed e.g., *'npm i --package-lock-only'*

    ```bash
    # Execute bash to docker containing CxSCA resolver
    # replace $PROJ_DIR with the source code path
    docker run -v $PROJ_DIR:/data --entrypoint bash cxsca-resolver:1.5.45
    
    # Execute SCA scan command 
    /opt/sca/ScaResolver --authentication-server-url https://platform.checkmarx.net \
        -a <account> \
        -u <username> \
        -p <password> \
        -n <Project name> \
        -s /data

    # Execute dependency resolution, to see error. E.g., NPM
    npm i --package-lock-only

    ```

# References
CxSCA Resolver [[1]]  
CxSCA supported package managers [[2]]  
Nexus OSS [[3]]  
Using Nexus 3 as your repository [[4]]  

[1]:https://checkmarx.atlassian.net/wiki/spaces/CD/pages/2010809574/CxSCA+Resolver "CxSCA Resolver"
[2]:https://checkmarx.atlassian.net/wiki/spaces/CD/pages/1975713967/CxSCA+Resolver+Package+Manager+Support "CxSCA supported package managers"
[3]:https://help.sonatype.com/repomanager3 "Nexus OSS"
[4]:https://blog.sonatype.com/using-nexus-3-as-your-repository-part-2-npm-packages "Using Nexus 3 as your repository"

<!-- 
Installing Nessus Repo
https://hub.docker.com/r/sonatype/nexus3/
-->