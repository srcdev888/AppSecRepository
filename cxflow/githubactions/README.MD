# CxFlow with Github Actions

* Author:   Pedric Kng  
* Updated:  07 Oct 2020

## Overview
This article describes how to include CxFlow implementation with Github Actions

***
## Pre-requisites
- Checkmarx CxFlow Github action[[1]] 

  The Checkmarx Github action spin up a CxFlow docker container and execute via passing respective arguments. 
  
  By default, the Github action will generate the Sarif report format which can be parsed and uploaded into Github security dashboard. This can be reconfigured to create issues in other CxFlow supported trackers, do refer to CxFlow documentation.

  For 9.0, note that the version to use is 'v1.0-9.x' at the time of writing(Oct-20).

- Checkmarx CxSAST 8.9/9.x

- Knowledge on [Github actions](https://docs.github.com/en/free-pro-team@latest/actions/learn-github-actions/introduction-to-github-actions)

## Configuration

**Step1** : Add the Cx Github action via the Github portal

The example below is extracted from [[2]], and supports Cx SAST scanning via commit to the 'master' branch'.

Please refer to [[1]] for the supported variables with Cx Github Action, and configure as required. 

```yml
# https://github.com/cx-demo/cxflow-JavaVulnerableLab/blob/master/.github/workflows/checkmarx-cxflow-github-action.yml

name: checkmarx-cxflow-github-action

on:
  push:
    branches: [ master ]
  #pull_request:
  #  branches: [ master ]

jobs:
  build:

    runs-on: ubuntu-latest
    env : #Set the environment variables for RepoName and PR number.
      REPO_NAME: ${{ github.event.repository.name }}
      BR_NAME: ${{ github.head_ref }} 
      PR_NUMBER: ${{ github.event.number }}

    steps:
    - uses: actions/checkout@v2
    - name: Set up JDK 1.8
      uses: actions/setup-java@v1
      with:
        java-version: 1.8
    
    # Extract the short branch name
    - name: Extract branch name
      shell: bash
      run: echo "##[set-output name=branch;]$(echo ${GITHUB_REF#refs/heads/})"
      id: extract_branch
    
    # Extracts the Org name from GitHub's environment variables and stores in another env variable.
    - name: Get the Organization Name
      run: echo ::set-env name=ORG_NAME::$(echo "$GITHUB_REPOSITORY" | awk -F / '{print $1}')
    
    # Runs the Checkmarx Scan leveraging the latest version of CxFlow - REFER to Action README for list of inputs
    - name: Checkmarx CxFlow Action
      uses: checkmarx-ts/checkmarx-cxflow-github-action@v1.0-9.x
      with:
        project: ${{ env.REPO_NAME }}-${{ steps.extract_branch.outputs.branch }}
        team: 'CxServer/CxFlow/Github/${{ env.ORG_NAME }}'
        checkmarx_url: ${{ secrets.CHECKMARX_URL }}
        checkmarx_username: ${{ secrets.CHECKMARX_USERNAME }}
        checkmarx_password: ${{ secrets.CHECKMARX_PASSWORD }}
        checkmarx_client_secret: ${{ secrets.CHECKMARX_CLIENT_SECRET }}
        incremental: false
    
    # Upload the Report for CodeQL/Security Alerts
    - name: Upload SARIF file
      uses: github/codeql-action/upload-sarif@v1
      with:
        sarif_file: cx.sarif
    
    # Build the JavaVulnerableLab project
    - name: Build with Maven
      run: mvn -B package --file pom.xml

```

Github actions are triggered via [events](https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows), and event payload variable is available for usage in action yml file 

E.g., [webhook push event payload  ](https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows#push)

```yml
${{ github.event.repository.name }}
```


**Step2** : Configure the action variables via Github Secrets[5]

Below are some configurable variables used by the example shown in step 1.

| Name          | Type          | Description         |
| ------------- |---------------|---------------------|
| CHECKMARX_CLIENT_SECRET      | Client secret     | Client secret to connect to CxSAST REST API          |
| CHECKMARX_USERNAME  | Cx Username     | CxSAST username       |
| CHECKMARX_PASSWORD   | Cx User Password     | CxSAST user password |
| CHECKMARX_URL        | CxSAST URL     | URL to CxSAST e.g., http://localhost      |



## More examples

[Sample workflow for Pull request](https://github.com/checkmarx-ts/checkmarx-cxflow-github-action/blob/master/sample-workflow-pull-request.yml)

[Sample workflow for Push and Pull request, including upload sarif report format to Github security dashboard](https://github.com/checkmarx-ts/checkmarx-cxflow-github-action/blob/master/sample-workflow.yml)



## References
Checkmarx CxFlow Github Action [[1]]  
Example CxFlow with JavaVulnerableLab [[2]]  
Github Action environment variables [[3]]  
Github webhook payload [[4]]  
Github encrypted secrets [[5]]    

[1]:https://github.com/marketplace/actions/checkmarx-cxflow-action "Checkmarx CxFlow Github Action"
[2]:https://github.com/cx-demo/cxflow-JavaVulnerableLab "Example CxFlow with JavaVulnerableLab"
[3]:https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables "Github Action environment variables"
[4]:https://developer.github.com/webhooks/event-payloads/ "Github webhook payload"
[5]:https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets "Github encrypted secrets"