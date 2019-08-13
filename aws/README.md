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

***

# CxSAST Integrations

## CodeCommit
CxSAST support out-of-the box pulling source code from Git repository, this is usually practiced in a Security Gate model; whereby testing is executed in the last phase of development and no build servers is deployed.

Currently, AWS CodeCommit supports both HTTPS(username + password) and SSH mechanism to interact with the CodeCommit repository [[2]]. Both mechanisms are supported with Checkmarx CxSAST [[1]].

Note that managing credentials in GIT client via AWS CLI Credential Helper(through an Access Key ID and Secret Access Key) is not supported by CxSAST.

## CodeBuild
[Invoking CxSAST from AWS CodeBuild](codebuild/README.md)  

## CodePipeline
There are two means to integrate CxSAST with AWS CodePipeline, namely;
- As part of CodeBuild, refer to [CodeBuild Integration](codebuild/README.md)  
- [Invoking CxSAST as a custom action](https://github.com/cx-demo/aws-codepipeline-cx-job-worker)

***

# AWS CLI Cheat sheet
For AWS CLI installation, refer to [[4]]

## Create login profiles
```Batchfile
aws configure [--profile profile-name]
```
In addition, you can alter the entries in the AWS CLI files;  

- %user_profile%\\.aws\\credentials

```ini
[default]
aws_access_key_id = *AWS ACCESS KEY*
aws_secret_access_key = *AWS SECRET ACCESS KEY*

[CodeCommitProfile]
aws_access_key_id = *AWS ACCESS KEY*
aws_secret_access_key = *AWS SECRET ACCESS KEY*
```
- %user_profile%\\.aws\\config

```ini
[default]
output = json
region = us-east-1

[profile CodeCommitProfile]
region = ap-southeast-1
output = json
```

Refer to [[5]] for more details

## List configuration
```Batchfile
aws configure list [--profile profile-name]
```

## List AMI images
```Batchfile
aws ec2 describe-images --filters "Name=tag:Name,Values=<AMI Name>" [--profile profile-name]
```

## Create new instance from AMI
```Batchfile
aws ec2 run-instances --region us-east-1 --image-id <Replace with AMI ID>  --count 1 --instance-type r5.xlarge --security-group-ids sg-08ca8e460f086caa9 --subnet-id subnet-03221d4d303e3893d --associate-public-ip-address --tag-specifications "ResourceType=instance,Tags=[{Key=owner,Value=<Replace with UserName>}]" "ResourceType=volume,Tags=[{Key=owner,Value=<Replace with UserName>}]"
```

## List instances
```Batchfile
aws ec2 describe-instances --filters "Name=tag:owner,Values=<Replace with UserName>" [--profile profile-name]

aws ec2 describe-instances --instance-id <Replace with InstanceID> [--profile profile-name]
```

## Start instance
```Batchfile
aws ec2 start-instances --instance-id <Replace with InstanceID> [--profile profile-name]
```

## Stop instances
```Batchfile
aws ec2 stop-instances --instance-id <Replace with InstanceID> [--profile profile-name]
```

## Terminate instances
```Batchfile
aws ec2 terminate-instances --instance-id <Replace with InstanceID> [--profile profile-name]
```

# References
Configuring the Connection to a Source Control System on CxSAST [[1]]  
Git with AWS CodeCommit Tutorial [[2]]  
Introducing Git Credentials: A Simple Way to Connect to AWS CodeCommit Repositories Using a Static User Name and Password [[3]]  
Install the AWS Command Line Interface on Microsoft Windows [[4]]  
AWS CLI Name Profile Configuration [[5]]  
AWS CLI Command Reference [[6]]  

[1]:https://checkmarx.atlassian.net/wiki/spaces/KC/pages/324927625/Configuring+the+Connection+to+a+Source+Control+System+v8.6.0+and+up "Configuring the Connection to a Source Control System"
[2]:https://docs.aws.amazon.com/codecommit/latest/userguide/getting-started.html#getting-started-create-repo "Git with AWS CodeCommit Tutorial"
[3]:https://aws.amazon.com/blogs/devops/introducing-git-credentials-a-simple-way-to-connect-to-aws-codecommit-repositories-using-a-static-user-name-and-password/ "Introducing Git Credentials: A Simple Way to Connect to AWS CodeCommit Repositories Using a Static User Name and Password"
[4]:https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-windows.html#awscli-install-windows-path "Install the AWS Command Line Interface on Microsoft Windows"
[5]:https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html "AWS CLI Name Profile Configuration"
[6]:https://docs.aws.amazon.com/cli/latest/index.html "AWS CLI Command Reference"

<!--
### Connecting to AWS CodeCommit using aws cli credentials helper (not working)
1. Validate that you have followed [[1]] to setup the AWS Command; note that Python 3.6 and pip is required.
2. Setup a 'CodeCommitProfile' profile in "%user_profile%\\.aws\\credentials"

```yaml
[default]

[CodeCommitProfile]
aws_access_key_id = *AWS ACCESS KEY*
aws_secret_access_key = *AWS SECRET ACCESS KEY*
```
3. Configure additional credential in "%user_profile%\\.gitconfig" for AWS CodeCommit, give the credential a particular domain setting. This can prevent it from overriding other GIT credential e.g., Windows Credential for GitHub.

```yaml
[gui]
[user]
	email = abc@gmail.com
	name = abc
[credential]
    helper = wincred
[credential "https://git-codecommit.*.amazonaws.com"]
	helper = !aws --profile CodeCommitProfile codecommit credential-helper $@
	UseHttpPath = true
```
Using CodeCommit and Github credentials [[4]]

[4]:https://jameswing.net/aws/using-codecommit-and-git-credentials.html "Using CodeCommit and Github credentials"
-->
