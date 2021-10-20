# Extending dockerized CxAST CLI to use CxSCA Resolver 
* Author:   Pedric Kng  
* Updated:  20-Oct-21

This article describes the extension of CxAST CLI to support CxSCA Resolver for private repository resolution

***

## Getting Started

In this example, we are extending the dockerized CxAST CLI [[4]] to support CxSCA Resolver

1. Create dockerfile 

    [Example Dockerfile](dockerfile)

    ```docker
    FROM checkmarx/ast-cli:latest

    ARG VERSION

    RUN echo ${VERSION}

    # Install main dependencies
    RUN apt-get update && \
        apt-get -y install ca-certificates && \
        apt-get -y install wget && \
        apt-get -y install locales locales-all

    ENV LC_ALL en_US.UTF-8
    ENV LANG en_US.UTF-8
    ENV LANGUAGE en_US.UTF-8

    RUN apt -q install ruby-full -y && \
        apt-get install -y --no-install-recommends ruby ruby-dev make gcc libcurl4 libc6-dev git && \
        gem install cocoapods

    # Test if pod is installed
    # pod --version --allow-root

    WORKDIR /opt/sca

    # Download SCA Resolver
    RUN wget https://sca-downloads.s3.amazonaws.com/cli/${VERSION}/ScaResolver-linux64.tar.gz -O ScaResolver-linux64.tar.gz && \
        tar -xzvf ScaResolver-linux64.tar.gz && \
        rm -rf ScaResolver-linux64.tar.gz && \
        chmod +x ScaResolver && \
        ls -la

    # Test if dependencies resolution is possible
    # pod install --allow-root

    ENTRYPOINT ["/app/bin/cx"]
    ```

2. Build container

    ```bash
    # The latest version of CxSCA resolver is 1.5.45 at writing
    docker build -t ast-scaresolver-cocoa:latest --build-arg VERSION=1.5.45 .

    # Test if AST CLI is executing well
    docker run --rm ast-scaresolver-cocoa:latest
    ```

3. Execute AST scan

    ```sh
    #!/bin/sh -x

    # CxAST Cloud
    DEBUG='--debug'
    URL_BASE='--base-uri https://eu.ast.checkmarx.net'
    URL_AUTH='--base-auth-uri https://eu.iam.checkmarx.net'
    AGENT='--agent MyASTCLI'
    TENANT='--tenant <TENANT>'
    APIKEY='--apikey <API KEY>'

    # Project Properties
    PROJECT_NAME='--project-name <PROJECT NAME>'
    PRESET='--sast-preset-name <PRESET>'
    SCANTYPE='--scan-types sast,sca,kics'

    ## This is hardcoded to /data in container
    SCAN_PATH='--file-source /data'
    SCA_RESOLVER='--sca-resolver /opt/sca/ScaResolver'
    BRANCH='--branch <BRANCH>'
    PROJ_DIR='<SOURCE DIRECTORY>'

    # Note that we mount physical project directory to /data
    docker run --rm -v $PROJ_DIR:/data ast-scaresolver-cocoa:latest scan create $DEBUG $URL_BASE $URL_AUTH $AGENT $TENANT $APIKEY $PROJECT_NAME $PRESET $SCANTYPE $BRANCH $SCA_RESOLVER $SCAN_PATH

    ```


# References
CxSCA Resolver [[1]]  
AST-CLI [[2]]  
CxAST CLI KC [[3]]  
Dockerhub AST-CLI [[4]]

[1]:https://checkmarx.atlassian.net/wiki/spaces/CD/pages/2010809574/CxSCA+Resolver "CxSCA Resolver"
[2]: https://github.com/Checkmarx/ast-cli "AST-CLI"
[3]: https://checkmarx.atlassian.net/wiki/spaces/AST/pages/2445443121/CLI+Tool "CxAST CLI KC"
[4]:https://hub.docker.com/r/checkmarx/ast-cli "Dockerhub AST-CLI"


