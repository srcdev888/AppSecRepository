# AWS Integration with Checkmarx CxSAST  
* Author:   Pedric Kng  
* Updated:  26 Sept 2018

Sharing on integration of Checkmarx CxSAST and CxOSA with AWS CodeCommit and CodePipeline.

## AWS Technologies
* AWS CodeCommit - GIT Repository equivalent to Github
* AWS CodePipeline
* AWS CodeBuild
* AWS CodeDeploy
* AWS CloudFormation

***

## Troubleshooting

### Connecting to AWS CodeCommit using username and Password
Refer to [[5]]

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
Referenced from blog [[4]]

## References
Install the AWS Command Line Interface on Microsoft Windows [[1]]  
AWS CLI Name Profile Configuration [[2]]  
Git with AWS CodeCommit Tutorial [[3]]  
Using CodeCommit and Github credentials [[4]]
Introducing Git Credentials: A Simple Way to Connect to AWS CodeCommit Repositories Using a Static User Name and Password [[5]]

[1]:https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-windows.html#awscli-install-windows-path "Install the AWS Command Line Interface on Microsoft Windows"
[2]:https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html "AWS CLI Name Profile Configuration"
[3]:https://docs.aws.amazon.com/codecommit/latest/userguide/getting-started.html#getting-started-create-repo "Git with AWS CodeCommit Tutorial"
[4]:https://jameswing.net/aws/using-codecommit-and-git-credentials.html "Using CodeCommit and Github credentials"
[5]:https://aws.amazon.com/blogs/devops/introducing-git-credentials-a-simple-way-to-connect-to-aws-codecommit-repositories-using-a-static-user-name-and-password/ "Introducing Git Credentials: A Simple Way to Connect to AWS CodeCommit Repositories Using a Static User Name and Password"
