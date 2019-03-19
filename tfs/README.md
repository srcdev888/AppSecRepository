# Azure DevOps and TFS Issue Tracking with Checkmarx
* Author:   Pedric Kng  
* Updated:  18 Mar 2019

Azure DevOps (formally VSTS) or TFS (Team Foundation Server) is a common tool to use for planning development backlogs. This integration will describe the pushing of Checkmarx scan results (xml report) as work items to be managed.

### Compliments
This tutorial was only possible through the hard work of https://github.com/CxTyler

***
## Pre-requisites
- Azure DevOps & TFS (2015,2017,2018)
  - REST API access
  - Permission to create additional item Fields
- CxSAST xml scan result report

## Steps
1.	Generate CxSAST XML Results (Post-Scan Action or Manually Generated)
2.	Setup Custom Fields within Azure DevOps (formally VSTS) or TFS (Team Foundation Server) under Work Item Type named 'Bug'

| Field     | Description               |
| ------------- |---------------------------|
| Similarity ID | Checkmarx specific field to identify a unique Vulnerability     |
| Node ID       | Checkmarx specific field to identify a unique node for each Result |

3.	Create Customer Script to parse the XML report for relevant issue tracking data
  - Vulnerability Name
  - Source Filename  
  - Destination Filename  
  - Assignee  
  - Severity  
  - Priority  
  - Deep link  

4.	Read result entries and create new work items in Azure DevOps/TFS via custom script. Requires Microsoft's REST APIs[[3]] and authentication token [[8]] to utilize API calls to create/update/delete Work Items.
  - TFS2018 Work Item script source [[6]]
  - Azure DevOps Work Item script source [[7]]

### Example for TFS  
1. Use WitAdmin [[1]] to export out Work Item Type (WIT) definition named 'Bug'
```shell
witadmin exportwitd /collection:%COLLECTIONURL% /p:%PROJECTNAME% /f:%FILENAME% /n:Bug
```
2. Edit the WIT definition file to add in the customized fields [[2]];
```XML
<FIELDS>
  ...
  <FIELD name="Similarity ID" refname="Checkmarx.SimilarityID" type="String" />
  <FIELD name="Node ID" refname="Checkmarx.NodeID" type="String" />
  ...
</FIELDS>
<FORM>
  ...
    <Control Label="Similarity ID" Type="FieldControl" FieldName="Checkmarx.SimilarityID" ReadOnly="True" />
    <Control Label="Node ID" Type="FieldControl" FieldName="Checkmarx.NodeID" ReadOnly="True" />
  ...
</FORM>
```
3. Import the edited definition using WitAdmin [[1]]
Tip: use additional parameter [/v] to validate the definition before importing.
```shell
witadmin importwitd /collection:CollectionURL [/p:Project] /f:FileName [/e:Encoding] [/v]
```
4. Refresh the portal page to view the changes
5. Export the XML Report from CxSAST
6. Edit the global variables in script 'CxTFS2017.py' [[6]]  

  Note:
    - authenticate using Personal Access Token (PAT) [[10]] to authenticate to the TFS
    - usage of library 'keyring' [[9]] to store the authentication token in the base64 encoded {username}:{personalaccesstoken}

| Variables     | Description               |
| ------------- |---------------------------|
| MAX_CX_RESULTS | Max number of results to be imported |
| CXSAST_RESULTS_XML | Path of CxSAST XML Report |
| SERVICE_NAME | Keyring service name |
| API_VERSION | Azure DevOps/TFS API Version [[3]] |
| USER_NAME | Azure DevOps/TFS username |
| TFS2017_URL | Azure DevOps/TFS Collection URL e.g., http://localhost:8081/tfs/DefaultCollection/ |
| PROJECT_NAME | Azure DevOps/TFS project name |
| SIMILARITY_ID_FIELD | Azure DevOps/TFS customized 'Similarity ID' field name e.g., Checkmarx.SimilarityID |
| NODE_ID_FIELD | Azure DevOps/TFS customized 'Node ID' field name e.g., Checkmarx.NodeID |
| IGNORE_FP | ignore result flagged 'false-positive'; not imported |

7. Execute the python script, it will;
  - import in 'New' issues found in the report as work item
  - flag existing work item as 'Resolved' if no longer found in report

## References
Import, export, and manage work item types [[1]]  
Add or modify a field to track work [[2]]  
Azure DevOps/TFS REST API Versioning [[3]]  
Azure DevOps Work item API documentation [[4]]  
TFS Work Item API documentation [[5]]  
TFS2017 Work item script source [[6]]  
Azure DevOps Work Item script source [[7]]  
Azure DevOps/TFS REST API Authentication [[8]]  
Using PY Keyring [[9]]  
Authenticating with personal access tokens [[10]]  

[1]: https://docs.microsoft.com/en-us/azure/devops/reference/witadmin/witadmin-import-export-manage-wits "Import, export, and manage work item types"  
[2]: https://docs.microsoft.com/en-us/azure/devops/reference/add-modify-field?view=azure-devops-2019#to-add-a-custom-field "Add or modify a field to track work"  
[3]: https://docs.microsoft.com/en-us/azure/devops/integrate/concepts/rest-api-versioning?view=azure-devops "Azure DevOps/TFS REST API Versioning"
[4]: https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/?view=azure-devops-rest-4.1 "Azure DevOps Work item API documentation"
[5]: https://docs.microsoft.com/en-us/azure/devops/integrate/previous-apis/wit/work-items?view=tfs-2017 "TFS Work Item API documentation"
[6]: https://github.com/CxTyler/TFS2017-Defect-Tracking "TFS2017 Work Item script source"
[7]:https://github.com/CxTyler/Azure-DevOps-Defect-Tracking "Azure DevOps Work Item script source"
[8]: https://docs.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/pats?view=azure-devops "Azure DevOps/TFS REST API Authentication"
[9]: https://alexwlchan.net/2016/11/you-should-use-keyring/ "Using PY Keyring"
[10]: https://docs.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/pats?view=azure-devops "Authenticating with personal access tokens"
