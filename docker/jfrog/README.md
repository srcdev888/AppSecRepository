# JFrog Artifactory OSS setup
* Author:   Pedric Kng  
* Updated:  22 Jul 2021

This article describes how to setup maven private repository with JFrog Artifactory.

***
## Installation

1. Setting JFROG_HOME environment variable

    ```bash
    >> sudo nano /etc/environment

    # Add in the below environment
    >> JFROG_HOME=/demos/jfrog

    >> logout

    >> echo $JFROG_HOME

    ```

2. JFrog Artifactory OSS Docker installation

    ```bash
    mkdir -p $JFROG_HOME/artifactory/var/etc/
    cd $JFROG_HOME/artifactory/var/etc/
    touch ./system.yaml
    # UID and GID should be the user running the docker commands, execute 'id' to view all users
    chown -R $UID:$GID $JFROG_HOME/artifactory/var
    chmod -R 777 $JFROG_HOME/artifactory/var
    ```

    ```bash
    docker run --name artifactory -v $JFROG_HOME/artifactory/var/:/var/opt/jfrog/artifactory -d -p 9081:8081 -p 9082:8082 releases-docker.jfrog.io/jfrog/
    artifactory-oss:latest
    ```

3. Browse to http://localhost:9082/ui/
    ```bash
    #Default Credentials
    Username: admin
    Password: password
    ```

4. Follow steps in [JFrog quick setup][2] to setup a maven repository

5. Download the [settings.xml][3] and update the username/password

6. Execute maven, using the new settings.xml
   ```bash
   mvn --settings YourOwnSettings.xml clean install
   ```

## References
JFrog Docker Installation [[1]]  
JFrog Quick Setup [[2]]  
Generating maven settings.xml [[3]]  

[1]:https://www.jfrog.com/confluence/display/JFROG/Installing+Artifactory#InstallingArtifactory-DockerInstallation "JFrog Docker Installation"
[2]:https://www.jfrog.com/confluence/display/JFROG/Administration+Module#AdministrationModule-QuickSetup "JFrog Quick Setup"
[3]:https://www.jfrog.com/confluence/display/JFROG/Maven+Repository#MavenRepository-AutomaticallyGeneratingSettings "Generating maven settings.xml"