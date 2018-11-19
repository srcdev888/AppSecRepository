# Checkmarx CxSAST integration with AWS Integration
* Author:   Pedric Kng  
* Updated:  17 Nov 2018

AWS offers many different CI/CD platform;
* **CodeCommit** - GIT Repository equivalent to Github
* **CodeBuild** - Continuous integration service for build and test
* **AWS CodeDeploy** - Continuous deployment service into AWS instances
* **CodePipeline** - Continuous integration and delivery service; note that it integrates with various AWS solutions; CodeCommit (Source Stage), Codebuild (Build Stage), CodeDeploy (Deploy Stage).
* **CodeStar** - CodeStar provides a wizard based project type selection to kickstart your application development
* **AWS CloudFormation** - Model and provision all your cloud infrastructure resources; infrastructure-as-code

There are several ways to integrate CxSAST with a variety of Amazon CI environments, namely;
- Checkmarx CxSAST can pull source code from Amazon [CodeCommit](#CodeCommit) out-of-the-box for SAST scan
- Checkmarx CxSAST scan be invoked from Amazon [CodeBuild](#CodeBuild) as part of the pre-build phase
- Checkmarx CxSAST can be invoked in CodePipeline as part of [CodeBuild](#CodeBuild) or [through a Custom Action](#CodePipeline)

Regardless of integration, all scan results are centralized in Checkmarx CxSAST.

# CxSAST Integrations

## CodeCommit
CxSAST support out-of-the box pulling source code from Git repository, this is usually practiced in a Security Gate model; whereby testing is executed in the last phase of development and no build servers is deployed.

Currently, AWS CodeCommit supports both HTTPS(username + password) and SSH mechanism to interact with the CodeCommit repository [[2]]. Both mechanisms are supported with Checkmarx CxSAST [[1]].

Note that managing credentials in GIT client via AWS CLI Credential Helper( through an Access Key ID and Secret Access Key) is not supported by CxSAST.

## CodeBuild
[Invoking CxSAST from AWS CodeBuild](codebuild/README.md)  

## CodePipeline
There are two means to integrate CxSAST with AWS CodePipeline, namely;
- As part of CodeBuild, refer to [CodeBuild Integration](#Codebuild)  
- [Invoking CxSAST as a custom action](CodePipeline/README.md)

## References
Configuring the Connection to a Source Control System on CxSAST [[1]]  
Git with AWS CodeCommit Tutorial [[2]]  

[1]:https://checkmarx.atlassian.net/wiki/spaces/KC/pages/324927625/Configuring+the+Connection+to+a+Source+Control+System+v8.6.0+and+up "Configuring the Connection to a Source Control System"
[2]:https://docs.aws.amazon.com/codecommit/latest/userguide/getting-started.html#getting-started-create-repo "Git with AWS CodeCommit Tutorial"
