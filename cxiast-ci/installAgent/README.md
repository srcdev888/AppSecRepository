# Installing CxIAST Agent
* Author:   Pedric Kng  
* Updated:  02 Jul 2021


***
This article describes two methods to install the CxIAST agent on a containerized application

- Pre-requisites
    - Knowledge on the to-be-instrumented container Dockerfile
      If you do not have the Dockerfile, consider using Docker inspect to review the exec command
    - Capability to download and deploy a new CxIAST agent
      *Note: Always download a new agent for a new deployment, and not share agent installation*

The two methods are as below;
- [Method 1: Extending Dockerfile](#Method-1:-Extending-an-existing-Dockerfile)
- [Method 2: Implement additional instrumentation argument](#Method-2:-Implement-additional-instrumentation-argument)

## Method 1: Extending an existing Dockerfile

1. Review the existing container Dockerfile[[2]].

    Determine the existing Dockerfile working, this [image](https://hub.docker.com/r/psiinon/bodgeit) is based on standard [tomcat](https://docs.docker.com/docker-hub/official_repos/) deployment.

    The way to instrument a tomcat is by specifying the agent to the CATALINA_OPTS environment variable.

2. Create new [Dockerfile](method1/Dockerfile) to extend from the current image 

    ```docker
    FROM psiinon/bodgeit:latest

    # Support passing of CxIAST URL via argument, to be used to download the agent from CxIAST server
    ARG IAST_URL=192.168.137.70:8380
    ENV ENV_IAST_URL=${IAST_URL}

    # Install curl and unzip packages
    RUN apt-get -y update
    RUN apt-get install -y curl unzip

    # Download the CxIAST java agent to home folder
    RUN curl -o /home/cxiast-java-agent.zip http://${ENV_IAST_URL}/iast/compilation/download/JAVA && \
        unzip /home/cxiast-java-agent.zip -d /home/cxiast-java-agent && \
        rm -rf /home/cxiast-java-agent.zip && \
        chmod +x /home/cxiast-java-agent/cx-launcher.jar

    # Add the javaagent options to the tomcat catalina opts
    ENV CATALINA_OPTS="-javaagent:/home/cxiast-java-agent/cx-launcher.jar -Xverify:none"
    ```

3. Execute with the new Dockerfile

    ```bash

    # Build extended [Dockerfile](method1/Dockerfile)
    docker build -t psiinon/bodgeit:latest-iast - < Dockerfile

    # Add in the IAST Manager URL for Agent download
    export IAST_URL=192.168.137.70:8380

    # Execute application as per
    docker run --rm --env IAST_URL -p 8080:8080 -i -t psiinon/bodgeit:latest-iast

    ```

## Method 2: Implement additional instrumentation argument

The sample project is forked based on easybuggy4sb, variant based on Spring boot[[3]].

1. Docker file was added to the forked project

    ```docker
    FROM openjdk:8-jre-alpine
    LABEL maintainer="Pedric (cxdemosg@gmail.com)"

    ARG BUILDENV
    ARG IAST_URL=192.168.137.70:8380

    RUN apk update && apk add
    RUN adduser --system --home /home/easybuggy4sb easybuggy4sb
    RUN cd /home/easybuggy4sb/;
    RUN chgrp -R 0 /home/easybuggy4sb
    RUN chmod -R g=u /home/easybuggy4sb
    RUN apk add ca-certificates libstdc++ glib curl unzip

    USER easybuggy4sb
    WORKDIR /home/easybuggy4sb

    RUN if [ "$BUILDENV" = "TEST" ] ; then \
        curl -o cxiast-java-agent.zip http://${IAST_URL}/iast/compilation/download/JAVA && \
        unzip cxiast-java-agent.zip -d /home/easybuggy4sb/cxiast-java-agent && \
        rm -rf cxiast-java-agent.zip && \
        chmod +x /home/easybuggy4sb/cxiast-java-agent/cx-launcher.jar ; fi

    # if --build-arg env=TEST, set JAVA_TOOL_OPTIONS to 'CxIAST agent path' or set to null otherwise.
    ENV JAVA_TOOL_OPTIONS=${BUILDENV:+"-javaagent:/home/easybuggy4sb/cxiast-java-agent/cx-launcher.jar -Xverify:none"}
    ENV JAVA_TOOL_OPTIONS=${JAVA_TOOL_OPTIONS}

    COPY target/ROOT.war /home/easybuggy4sb/ROOT.war

    EXPOSE 8080

    CMD java -jar /home/easybuggy4sb/ROOT.war

    ```

2. Build project and container

```bash

    mvn package

    # Build without Agent
    docker build -t "cxdemosg/easybuggy4sb" .

    # Build to include agent download and configuration via additional build argument, else leave blank.
    # IAST_URL=IAST Manager URL, BUILDENV=TEST
    docker build -t "cxdemosg/easybuggy4sb" --build-arg IAST_URL='192.168.137.70:8380' --build-arg BUILDENV='TEST' .

```

3. Run container

```bash
docker run --rm --name=easybuggy4sb -d -p 8080:8080 -t "cxdemosg/easybuggy4sb"
```

## Method 3: Adding via JAVA_TOOL_OPTIONS

Note that this depends on whether the underlying application supports environment variable 'JAVA_TOOL_OPTIONS'

```bash
# Download the CxIAST agent
curl http://<IAST_SERVER>:8380/iast/compilation/download/JAVA --output agent.zip

# Unzip the CxIAST agent to a local folder
unzip agent.zip -d agent

# Pull the webgoat image
docker pull webgoat/webgoat-8.0

# Override JAVA_TOOL_OPTIONS to include the agent, and mount the agent directory
docker run \
    --rm \
    -it \
    --env JAVA_TOOL_OPTIONS="-javaagent:/tmp/agent/cx-launcher.jar" \
    --volume /demos/webgoat/agent:/tmp/agent \
    -p 8080:8080 \
    webgoat/webgoat-8.0

# Browse to http://<AUT_SERVER>:8080/WebGoat

```


## References
webgoat/goatandwolf:v8.1.0 [[1]]  
Bodgeit Dockerfile [[2]]    
Dockerized easybuggy4sb [[3]]  

[1]:https://hub.docker.com/layers/webgoat/goatandwolf/v8.1.0/images/sha256-1cd2a46d49d6880c85ba2df4a8e7ec1f9ce801e75f76de0639f99d7369b3138f?context=explore "webgoat/goatandwolf:v8.1.0"
[2]:https://github.com/psiinon/bodgeit/blob/master/Dockerfile ""
[3]:https://github.com/cx-demo/easybuggy4sb "Dockerized easybuggy4sb"