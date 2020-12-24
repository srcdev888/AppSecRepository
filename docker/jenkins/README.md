# Running Jenkins container
* Author:   Pedric Kng  
* Updated:  24 Dec 2020

This is a basic guide on running Jenkins container with Java JDK and Maven tooling

If you are interested in installing Jenkins container with Checkmarx plugin, refer to Jenkins container including Checkmarx plugin [[4]].

***
## Installation

1. Pull jenkins image
```bash
sudo docker pull jenkins/jenkins:lts
```

2. Create docker container based on Jenkins LTS version
```bash
sudo docker run -p 6080:8080 --name jenkins -v jenkins_home:/var/jenkins_home -v jenkins_downloads:/var/jenkins_home/downloads --restart always jenkins/jenkins:lts
```
 * **-p 6080:8080**: map the internal jenkins port to the external port

 * **--name jenkins**: name for the container

 * **-v jenkins_home:/var/jenkins_home**: internal jenkins home directory mapping to host machine

 * **-v jenkins_downloads:/var/jenkins_home/downloads**: download folder to copy the tooling installer

 * **--restart always**: [Container restart option](https://docs.docker.com/config/containers/start-containers-automatically/)

 * **jenkins/jenkins:lts**: Docker image to use i.e., Jenkins LTS version

3. Follow instructions on Jenkins web console (http://localhost:6080).  

  You can start and stop the container with these commands
  ```bash
  docker stop jenkins
  docker start jenkins
  ```

4. Install Java JDK

  a) Download the [Open JDK](https://adoptopenjdk.net/releases.html) and place it in the *jenkins_downloads* folder  

  b) Go to Jenkins > Global Tool Configuration > JDK  

  c) Add the JDK, specify "Extract *.zip/*.tar.gz"

  ![JDK Installation](assets/JDK.png)

    * **Download URL for binary archive**: file:/var/jenkins_home/downloads/OpenJDK11U-jdk_x64_linux_hotspot_11.0.6_10.tar.gz
    * **Subdirectory of extracted archive**: jdk-11.0.6+10  


5. Install Maven

  a) Download the [Maven](https://maven.apache.org/download.cgi?Preferred=ftp://mirror.reverse.net/pub/apache/#) and place it in the *jenkins_downloads* folder  

  b) Go to Jenkins > Global Tool Configuration > Maven

  c) Add the JDK, specify "Extract *.zip/*.tar.gz"

  ![Maven Installation](assets/maven.png)

  * **Download URL for binary archive**: file:/var/jenkins_home/downloads/apache-maven-3.6.3-bin.tar.gz
  * **Subdirectory of extracted archive**: apache-maven-3.6.3  


6. Remarks

  This post presents a quick way for having a running instance of Jenkins, but the recommendation is to leverage on Jenkins Jenkins docker pipeline where different tooling are self-contained within a container environment.  

  See example of Jenkins docker pipeline with CxCLI plugin [[5]]


## Quick management script 
[myjenkins.sh](myjenkins.sh)

## References
Start Docker Containers Automatically [[1]]  
Start containers automatically [[2]]  
Setup Jenkins CI in 30 Minutes [[3]]  
Jenkins container including Checkmarx plugin [[4]]  
Jenkins docker pipeline with CxCLI plugin [[5]]  

[1]:https://mehmandarov.com/start-docker-containers-automatically/ "Start Docker Containers Automatically"
[2]:https://docs.docker.com/config/containers/start-containers-automatically/ "Start containers automatically"
[3]:https://mydeveloperplanet.com/2019/01/30/setup-jenkins-ci-in-30-minutes/ "Setup Jenkins CI in 30 Minutes"
[4]:https://github.com/cx-demo/myjenkins.git "Jenkins container including Checkmarx plugin" 
[5]:https://github.com/cx-demo/MyAppSecRepository/jenkins-docker-pipeline "Jenkins docker pipeline with CxCLI plugin"