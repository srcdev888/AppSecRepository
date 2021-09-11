# Automated IAST Testing
* Author:   Pedric Kng  
* Updated:  03 Aug 2021

***
## Overview
In this article, we will build a Jenkins Pipeline that demostrates CxIAST testing with WebGoat 8. 
- use Jenkins BUILD_TAG as scan tag
- Deploy App with instrumentation (BUILD_TAG)
- Execute automated functional test
- Invoke CxFlow to open Jira tickets for new vulnerabilities

## Pre-requisites
- Installed All-in-One Jenkins that supports capability to execute Docker command
- Access to forked Webgoat Github repository [[1]]
  - The Webgoat is altered to allow specifying target URL with the integration test 
- Setup a docker bridge network to allow connection between the running containers
  ```bash
    # Create docker bridge network 'my-net'
    docker network create -d bridge my-net
  ```

## Outline
1. [Pull source and build](#Pull-source-and-build)
2. [Build container](#Build-container)
3. [Instrumenting Webgoat & Webwolf](#Instrumenting-Webgoat-&-Webwolf)
4. [Automated Functional Testing](#Automated-Functional-Testing)
5. [Orchestrate Jira ticketing with CxFlow](#Orchestrate-Jira-ticketing-with-CxFlow)

The sample Jenkins pipeline script is located [here](Jenkinsfile)


### Pull source and build

In this step, we pull the source code and execute maven build.

*Note that this example will only work for the the referenced repository [[2]]

```groovy
stage('Pull Source') {
    steps{
        checkout([
        $class: 'GitSCM',
        branches: [[name: "refs/tags/${params.GIT_TAG}"]],
        userRemoteConfigs: [[
            url: "${gitUrl}",
            credentialsId: '',
        ]]
        ])    
    }
}
stage('Build source'){
    steps{
        echo 'build source'
        withMaven(
            // Maven installation declared in the Jenkins "Global Tool Configuration"
            maven: 'maven3', // (1)
            
            // Use `$WORKSPACE/.repository` for local repository folder to avoid shared repositories
            //mavenLocalRepo: '.repository', // (2)
            
            // Maven settings.xml file defined with the Jenkins Config File Provider Plugin
            // We recommend to define Maven settings.xml globally at the folder level using
            // navigating to the folder configuration in the section "Pipeline Maven Configuration / Override global Maven configuration"
            // or globally to the entire master navigating to  "Manage Jenkins / Global Tools Configuration"
            mavenSettingsConfig: "${params.MVN_SETTINGS_CONFIG}" // (3)
        ) {
            // Run the maven build
            sh "mvn -DskipTests install"
        }
        
        
    }
}
```

### Build container

We build the WebGoat and WebWolf image, the images is automatically been pushed to the local registry

```groovy
stage('Build docker, push to registry'){
    steps{
        echo 'build docker'
            
        dir("./webgoat-server") {
            sh "pwd"
            script{
                dockerWebGoatImage = docker.build("${webGoatimageName}", "--build-arg webgoat_version=${params.APP_VERSION} -f Dockerfile .")
                // Push to docker registry
                //dockerImage.push()    
            }
        }
        
        dir("./webwolf") {
            sh "pwd"
            script{
                dockerWebWolfImage = docker.build("${webWolfImageName}", "--build-arg webwolf_version=${params.APP_VERSION} -f Dockerfile .")
            }
        }
        
    }
}
```

### Instrumenting Webgoat & Webwolf 

Prior to instrumenting the WebGoat & Webwolf container, we need to download the CxIAST agent to a folder

```bash
# Download the CxIAST agent
curl http://<IAST_SERVER>:8380/iast/compilation/download/JAVA --output /demo/webgoat8/agent.zip

# Unzip the CxIAST agent to a local folder
unzip /demo/webgoat8/agent.zip -d /demo/webgoat8/agent
```

In the next stage, we will deploy the instrumented WebGoat via the java environment variable 'JAVA_TOOL_OPTIONS'

```groovy

 stage('Deploy Instrumented Application'){
    steps{
        echo 'Deploy Instrumented Application'
        
        // Deploy WebGoat container
        script {
            dockerWebGoatImage = docker.image('${webGoatimageName}')
            
            // Override JAVA_TOOL_OPTIONS to include the agent, and mount the agent directory
            // The jenkins build number as part of the IAST scan tag, this aids us in determining which scan to stop and pull results from.
            // Note: 
            // (1) The scan tag should only contain alphanumeric character and dash, lesser than 256 in length
            // (2) The bridge network is specified so that docker networking is possible via the container name 

            containerWebGoat = dockerWebGoatImage.run("-it --env JAVA_TOOL_OPTIONS='-javaagent:/tmp/agent/cx-launcher.jar -DcxScanTag=Webgoat8-${BUILD_NUMBER}' --volume /demos/webgoat8/agent:/tmp/agent --name webgoat --network my-net -p 8080:8080 -p 9001:9001")    
        
        }
        
        // Wait for WebGoat application to be up
        sleep time: 120, unit: 'SECONDS'
        
        // Validate that the WebGoat application is accessible http://<url>:8080/Webgoat/login
        timeout(5) {
            waitUntil {
                script {
                    try{
                        final String url = "${appUrl}" 
                        def http_code  = sh(script: "curl -sLik -o /dev/null -w '%{http_code}' ${url}", returnStdout: true) as Integer 
                        
                        echo "${http_code}"
                        return (http_code == 200)
                    }
                    catch(err) {
                        echo "Caught: ${err}"
                        return false
                    }
                }
            }
        }
        
        // Deploy WebWolf container
        script {
            // Start WebWolf
            dockerWebWolfImage = docker.image('${webWolfImageName}')

            // WebWolf depends on a database, which is referenced from WebGoat container 
            containerWebWolf = dockerWebWolfImage.run("--name webwolf --network my-net -p 9090:9090",  "--spring.datasource.url=jdbc:hsqldb:hsql://webgoat:9001/webgoat --server.address=0.0.0.0" )    
        }
        
        // Wait for application to be up
        sleep time: 60, unit: 'SECONDS'
        
    }
}
```

    !!! Note that the following ports are hardcoded in the demo web application - WebGoat and WebWolf. and traffic should be allowed between both containers.

    | Port | Description |
    | ------------- | ------------- |
    | 8080 | WebGoat |
    | 9001 | HSQLDB, hosted in WebGoat |
    | 9090 | WebWolf |

### Automated Functional Testing

The functional test suite is based on WebGoat-Integration-tests module, and requires maven to execute.

```groovy
stage('Functional Test'){
    steps{
        echo 'Functional Test'
        
        dir("./webgoat-integration-tests") {
            
            script {
                
                try{
                    // Note that the hostname refers to the hosted WebGoat and WebWolf container's ip address
                    sh "mvn -DWEBGOAT_HOSTNAME=${params.HOSTNODE} -DWEBWOLF_HOSTNAME=${params.HOSTNODE} test"    
                }catch(err){
                    echo "Failed: ${err}"
                }
            }
            
        }        
        
    }
}
```
### Orchestrate Jira ticketing with CxFlow

In this step, we will leverage on CxFlow to process the scan results;
- Stop the scan based on the SCAN_TAG, and retrieve the results
- Create jira tickets for new vulnerabilities, and applied 'filter-severity'

        !!! Note that CxFlow only supports creation of new Jira tickets

- Fail pipeline upon exceeding 'threshold-severity'

```groovy
stage('Process scan results'){
    steps{
        echo 'Process scan results'
        script {
            docker.image('checkmarx/cx-flow:1.6.22-8').inside("--entrypoint ''") {
                sh 'printenv'
                sh 'echo BUILD_NUMBER: ${BUILD_NUMBER}'
                sh 'echo APP_VERSION: ${APP_VERSION}'
                sh """
                    java -Xms512m -Xmx1024m -Djavax.net.debug=ssl,handshake \
                        -Djava.security.egd='file:/dev/./urandom' \
                        -jar /app/cx-flow.jar \
                        --iast \
                        --cx-flow.bug-tracker=jira \
                        --assignee=${params.JIRA_USERNAME} \
                        --scan-tag=Webgoat8-${BUILD_NUMBER} \
                        --repo-name=webgoat8 \
                        --branch=${APP_VERSION} \
                        --iast.url='http://${params.IAST_URL}' \
                        --iast.manager-port=${params.IAST_PORT} \
                        --iast.username=${params.IAST_USERNAME} \
                        --iast.password=${params.IAST_PASSWORD} \
                        --iast.update-token-seconds=250 \
                        --iast.filter-severity=high \
                        --iast.filter-severity=medium \
                        --iast.thresholds-severity.high=1 \
                        --iast.thresholds-severity.medium=3 \
                        --iast.thresholds-severity.low=10 \
                        --iast.thresholds-severity.info=-1 \
                        --jira.url=${params.JIRA_URL} \
                        --jira.username=${params.JIRA_USERNAME} \
                        --jira.token=${params.JIRA_TOKEN} \
                        --jira.project=${params.JIRA_PROJECT} \
                        --jira.issue-type=Bug \
                        --cx-flow.break-build=true
                """
            }
        }
    }
}

```

## References
WebGoat 8.1.0_env [[1]]  
CxFlow CxIAST Integration [[2]]

[1]:https://github.com/cx-demo/WebGoat/releases/tag/v8.1.0_env "WebGoat 8.1.0_env"
[2]:https://github.com/checkmarx-ltd/cx-flow/wiki/CxIAST-Integration "CxFlow CxIAST Integration"


<!--
WebGoat8 Selenium [[3]  
Forked WebGoat8 Selenium [[4]]  
Chrome Driver [[5]]  

[3]:https://github.com/contrastsecurity/WebGoat8-Selenium "WebGoat8 Selenium"
[4]:https://github.com/cx-demo/WebGoat8-Selenium.git "Forked WebGoat8 Selenium"
[5]:https://chromedriver.chromium.org/getting-started "Chrome Driver"

-->