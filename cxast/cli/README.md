# Executing AST scans in CLI mode

- Author: Pedric Kng
- Updated: 22 Sept 2021

This write-up describes the execution of CxAST scan via CLI mode, and CxAST CLI version at writing is 2.0.0-rc.23.d.

---

## Installation
CxAST CLI is available for windows, mac, linux and docker platform 
- Windows/Mac/Linux: https://github.com/Checkmarx/ast-cli/releases
- Docker: https://hub.docker.com/r/checkmarx/ast-cli

---

## Examples

1. Scan execution

    The [CxAST CLI Example](cxast-cli-scan-nowait.sh) below illustrates

    a. Pulling the source code into a shared folder, specified by '--file-source'

    b. Including additional filetype via specifying '--file-include', and excluding non-required files via '--file-filter'

    c. Specifying SAST, SCA and KICS scan via '--scan-types'

    d. Specifying the SAST scan preset '--scan-preset-name' 

    e. Indicating '--nowait' to scan and forget 

    ```sh
    #!/bin/bash
    # Sample on SAST, SCA & KICS scanning via CxAST CLI

    ## Global Properties
    agent="MyASTCLI"
    apikey="<api key>"

    ## Note that there exists US and EU instance
    base_auth_uri="https://eu.iam.checkmarx.net/"
    base_url="https://eu.ast.checkmarx.net/"
    tenant="<tenant>"

    ## Project Properties
    projectName="service-discovery-java-apps"

    ## Use scan presets below;
    ## 'Checkmarx Default' for Web and API applications
    ## 'Android' for Android
    ## 'Mobile' for ObjectiveC/Swift
    preset="Checkmarx Default"
    scantype="sast,sca,kics"

    ## Pull source code from git into a local folder
    GitURL=https://github.com/yevgenykuz/service-discovery-demo-parent.git
    filesource=$pwd/service-discovery-demo-parent
    branch="master"
    git clone --branch $branch $GitURL $filesource

    ## Execute Scans
    file_include="Dockerfile"
    file_filter="!.git,!.github,!docker-compose-cross-http.yml,!dotnet-core-apps,!nodejs-apps,!java-kafka-entry-point,!java-kafka-http-entry-point,!java-kafka-propagator,!java-kafka-sink,!java-rabbitmq-entry-point,!java-rabbitmq-http-entry-point,!java-rabbitmq-propagator,!java-rabbitmq-sink,!docker-compose-java-kafka.yml"
    tags="service-discovery-demo,java"

    ./cx scan create -v --agent $agent --apikey $apikey --base-auth-uri $base_auth_uri --base-uri $base_url --tenant $tenant --project-name $projectName --sast-preset-name $preset --scan-types $scantype --branch $branch --tags $tags --file-source $filesource --file-include $file_include --file-filter $file_filter --nowait
    ```
        
        Note:
        * If '--file-source' is configured for GIT private respository, please use username and password authentication e.g., http://username:token@github.com/username/repository.git
        * '--file-filter' does not support full path, only at folder level
        * '--file-filter' only applies when '--file-source' is a folder, and not Git url

    Equivalent [Windows Example](cxsast-cli-scan-nowait.cmd) also available.

2. Create Project

    ```bash
    #!/bin/bash -x
    # Sample on project creation via CxAST CLI
    # https://checkmarx.atlassian.net/wiki/spaces/AST/pages/2446065669/project

    ## Global Properties
    agent="MyASTCLI"
    apikey="<api key>"

    ## Note that there exists US and EU instance
    base_auth_uri="https://eu.iam.checkmarx.net/"
    base_url="https://eu.ast.checkmarx.net/"
    tenant="<tenant>"

    # Project Properties
    projectName="test-project2"

    # use tags to auto-assign project to application
    tags="test-project2,test-app"

    ./cx project create -v --agent "$agent" --apikey "$apikey" --base-auth-uri "$base_auth_uri" --base-uri "$base_url" --tenant "$tenant" --project-name "$projectName" --tags "$tags"

    ```


## Miscellaneous

- GitLab does not support username and access token authentication, this is workaround via deploy token instead [[3]].
    ```bash
    # Specify Deploy token 'username' and 'token'
    git clone "https://<username>:<deployed token>@gitlab.com/cxdemosg/service-discovery-demo-parent.git"
    ```
- Docker CLI Execution

    ```bash
    # Pull docker from dockerhub (https://hub.docker.com/r/checkmarx/ast-cli)
    docker pull checkmarx/ast-cli

    # execute ast cli scan via command lines
    docker run --rm checkmarx/ast-cli <arg>

    # Example: scan folder, remember to mount the folder path to the docker
    docker run --rm -v {path_to_host_folder_to_scan}:/path checkmarx/ast-cli scan create --file-source '/path' <args>
    ```

## References
AST-CLI [[1]]  
CxAST CLI KC [[2]]  

[1]: https://github.com/Checkmarx/ast-cli "AST-CLI"
[2]: https://checkmarx.atlassian.net/wiki/spaces/AST/pages/2445443121/CLI+Tool "CxAST CLI KC"
[3]: https://docs.gitlab.com/ee/user/project/deploy_tokens/#deploy-token-custom-username "GitLab Deploy token"