# TFVC with Azure DevOps via VSCode
* Author:   Pedric Kng  
* Updated:  22 April 2019

## Overview
This tutorial discusses
- Azure DevOps TVFS Repository Pulling
- VSCode IDE integration

***
## Pre-requisites

- Create a Personal Access Token (PAT) with All Scopes available in Azure DevOps Services [[3]]
- Ensure you have a TF command line client installed.
- Existing VS project

## Steps
1. Search for Azure Repos extension[[1]] in VS Code and select to install the one by Microsoft
2. Open <b>File -> Preferences -> Settings</b>
3. Edit the following in your <b>user settings -> Extension -> Azure Repos extension</b>  
  - Tfvc: Location -- Specify the path to Team Foundation tool(tf.exe)
    - VS2015 - <i>"C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\Common7\\IDE\\tf.exe"</i>
    - VS2017 - <i>"C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Enterprise\\Common7\\IDE\\CommonExtensions\\Microsoft\\TeamFoundation\\Team Explorer\\tf.exe"</i>
  - Tfvc: RestrictWorkspace -- Restrict the TFVC workspace to current open VS Code workspace
    - Select option

4. Open a local folder (repository), From View -> Command Palette -> team signin
5. Provide user name --> Enter --> Provide PAT to connect to TFS.


## References
Azure Repos VSCode extension [[1]]  
Team Foundation Version Control (TFVC) Support [[2]]  
Authenticate access with personal access tokens [[3]]  
TVFC [[4]]  

[1]: https://marketplace.visualstudio.com/items?itemName=ms-vsts.team "Azure Repos VSCode extension"
[2]: https://github.com/Microsoft/azure-repos-vscode/blob/master/TFVC_README.md#quick-start "Team Foundation Version Control (TFVC) Support"
[3]: https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops "Authenticate access with personal access tokens"
[4]: https://docs.microsoft.com/en-us/azure/devops/repos/tfvc/index?view=azure-devops "TVFC"
