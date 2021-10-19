# Executing AST scans in GITLAB CI

- Author: Pedric Kng
- Updated: 19 Oct 2021

---
## Getting started

A gitlab CI script [.cxast.yml](.cxast.yml) is been built based on AST-CLI[[1]], for the testing stage.

```yml
# file: .cxast.yml
# Include this file in your .gitlab-ci.yml file to automate & integrate Checkmarx security scans.
#
# These variables can be overridden in your .gitlab-ci.yml file or as envionrment variables.
#

variables:
  AST_CLI_EXE: "/app/bin/cx"
  AST_BASE_URI: "https://eu.ast.checkmarx.net/"
  AST_AGENT: "MyASTCLI"
  AST_TENANT: "${AST_TENANT}"
  AST_CLIENT_ID: "${AST_CLIENT_ID}"
  AST_CLIENT_SECRET: "${AST_CLIENT_SECRET}"
  AST_PROJECTNAME: "$CI_PROJECT_NAME"
  AST_SCANTYPE: "sast,sca,kics"
  SAST_SCAN_PRESET: "Checkmarx Default"
  OUTPUT_PATH: "cx_result"
  REPORT_FORMAT: "sarif"
  PARAMS: ""

ast-scan:
  stage: test
  rules:
    - if: '$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH'
  image:
    name: checkmarx/ast-cli
    entrypoint: ['']
  script:
    - ${AST_CLI_EXE} scan create 
        --agent "${AST_AGENT}" 
        --base-uri "${AST_BASE_URI}" 
        --client-id "${AST_CLIENT_ID}" 
        --client-secret "${AST_CLIENT_SECRET}" 
        --tenant "${AST_TENANT}" 
        --project-name "${AST_PROJECTNAME}" 
        --branch "${CI_COMMIT_BRANCH}" 
        --scan-types "${AST_SCANTYPE}" 
        --sast-preset-name "${SAST_SCAN_PRESET}" 
        --output-path "${OUTPUT_PATH}" 
        --report-format "${REPORT_FORMAT}" 
        --file-source . 
        ${PARAMS}
  artifacts:
    when: on_success
    paths:
      - "${OUTPUT_PATH}/*"
```

The cxast configurations are as follows;

| Fields        | Description   |
| ------------- |---------------|
| AST_BASE_URI  | CxAST URL (US-https://ast.checkmarx.net EU-https://eu.ast.checkmarx.net) |
| AST_TENANT    | CxAST Tenant name |
| AST_CLIENT_ID | CxAST OAuth Client ID |
| AST_CLIENT_SECRET | CxSAST OAuth Client Secret |
| AST_PROJECTNAME | Project name, default using environment CI_PROJECT_NAME |
| AST_SCANTYPE | AST scanners to use e.g., sast,sca,kics |
| SAST_SCAN_PRESET | SAST scan preset e.g., Checkmarx Default |
| REPORT_FORMAT | Report format e.g., json, summaryHTML, sarif, summaryConsole |
| PARAMS | Additional CxAST CLI parameters to add|

To include AST scans, include the scan into the existing pipeline

```yml
# file: .gitlab-ci.yml 

include:
  - local: '.cxast.yml'

variables:
  AST_SCANTYPE: "sast,sca,kics"
  
stages:
  - test
```

## References
AST-CLI [[1]]  
CxAST CLI KC [[2]]  

[1]: https://github.com/Checkmarx/ast-cli "AST-CLI"
[2]: https://checkmarx.atlassian.net/wiki/spaces/AST/pages/2445443121/CLI+Tool "CxAST CLI KC"
