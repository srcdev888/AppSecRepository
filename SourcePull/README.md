# CxSAST SAST/OSA scans with Source Pulling
* Author:   Pedric Kng  
* Updated:  16 Nov 2018

In typical security gate model deployment, there are no build servers. This presents a challenge with dependency sources which are not located in the same repository.

With CxSAST, customization can be performed using 'Source Pulling'; executing custom scripts to aggregate sources and dependencies from various locations to aid in executing SAST and OSA scans.

This section highlights the thought process to achieve this scenario.

## Flow Overview
1. Configure a shared Windows folder; note that corresponding write access should be given
2. Create batch script to pull source code and dependencies to the shared Windows folder E.g., Use 'py_git' [[1]] to pull source code, Execute maven dependencies download (mvn dependency:copy-dependencies)
3. Configure project with 'Source pulling' option to specify the shared folder and the executing batch script
4. Should OSA scan be required, remember to configure the OSA location with the shared folder
5. Invoke scans via 'CxSAST CLI' [[2]]


## Miscellenous
- If the folder to be scanned is located locally, you can specify _'\\localhost\c$\<folder>'_ as the path in the 'Shared folder' option. An important note for the network credentials is 

    | Field | Description |
    | ---| ---|
    | Username | Format is typically _'machine name/username'_. Note that the username is case-sensitive  |
    | Password | User password |



## References

Pulling Git repository with Python [[1]]  
CxConsole: CxSAST CLI [[2]]

[1]:https://github.com/cx-demo/py_git "PYGIT"  
[2]:https://checkmarx.atlassian.net/wiki/spaces/KC/pages/52560015/CxConsole+CxSAST+CLI "CxConsole: CxSAST CLI"
