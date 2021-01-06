*In-works

# Checkmarx integration tutorial with AWS CodePipeline
* Author:   Pedric Kng  
* Updated:  09 Oct 2020

AWS Code Pipeline offers integration through CodeBuild stages, this tutorial will illustrate how to integrated Checkmarx security scans (CxSAST, CxSCA and CxIAST) in the pipeline.

***
## Overview
The tutorial workflow will be broken as below;

Create a pipeline with various CodeBuild stages
   - Continuous Integration (CI): 
      1. [Stage 'Source'](#CI:-Stage-'Source'):
         - Pull the source code from Git repository
      2. [Stage 'Build Application'](#CI:-Stage-'Build'):
         - Build the application
         - Execute SAST & SCA
         - Send SAST & SCA tickets to Jira (CxFlow) 
         - Email alert on SAST & SCA scan completion via cloud watch on pipeline
      3. [Stage 'Build Container'](#CI:-Stage-'Build-Container'):
         - Build the docker image with the CxIAST agent
         - ~~Push the docker image into AWS ECR~~
   - Continuous Deployment (CD):  
      1. Stage 'Deploy Container':
         - ~~Deployment via AWS ECS~~
      2. Stage 'Automated functional testing':
         - ~~Automated functional testing for CxIAST~~
2. [Developer remediate via IDE](#Developer-IDE-remediation)
   1. Review the JIRA ticket as assigned
   2. Use IntelliJ IDE to remediate & execute private scan (validate that issue is fixed)
   3. Commit fixes to repository, invoke pipeline to close ticket for fix

## Preparation
For this tutorial, we will use the 
- WebGoat Legacy Fork [[1]]
  - Branch [Feature-awscodebuild](https://github.com/cx-demo/WebGoat-Legacy/tree/Feature-awscodebuild): 
  Contains AWS CodeBuild 'buildspec.yml'
  - Branch [Fix_SQL_Injection_Login](https://github.com/cx-demo/WebGoat-Legacy/tree/Feature-awscodebuild):  With SQL injection fix

## CI: Stage 'Source'

## CI: Stage 'Build'

## CI: Stage 'Build Container'

## Developer IDE remediation 


## References
WebGoat Legacy Fork [[1]]  

[1]:https://github.com/cx-demo/WebGoat-Legacy "WebGoat Legacy Fork"  