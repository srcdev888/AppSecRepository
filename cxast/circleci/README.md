# AST scan in CircleCI

- Author: Pedric Kng
- Updated: 28 Oct 2021

---
## Getting started

We will add a test stage 'ast-scan' to execute scan, through integrating AST-CLI Docker [[3]]in our Circle CI configuration file.

```yml
#.circleci/config.yml
version: 2.1

jobs:
  ast-scan:
    docker:
      - image: checkmarx/ast-cli
    steps:
    - checkout
    - run:
        name: Execute CxAST scan
        command: |
          /app/bin/cx scan create --agent "${AST_AGENT}" --base-uri "${AST_BASE_URI}" --client-id "${AST_CLIENT_ID}" --client-secret "${AST_CLIENT_SECRET}" --tenant "${AST_TENANT}" --project-name "${CIRCLE_PROJECT_REPONAME}" --branch "${CIRCLE_BRANCH}" --scan-types "${AST_SCANTYPE}" --sast-preset-name "${SAST_SCAN_PRESET}" --output-path "reports" --report-format "${REPORT_FORMAT}" --file-source . ${PARAMS}
    - store_artifacts:
        path: "reports"

workflows:
  ast-workflow:
    jobs:
      - ast-scan
```

Store the following cxast configurations as environment variables

| Fields        | Description   |
| ------------- |---------------|
| AST_AGENT | CxAST agent name, recommended to set to scan origin |
| AST_BASE_URI  | CxAST URL (US-https://ast.checkmarx.net EU-https://eu.ast.checkmarx.net) |
| AST_TENANT    | CxAST Tenant name |
| AST_CLIENT_ID | CxAST OAuth Client ID |
| AST_CLIENT_SECRET | CxSAST OAuth Client Secret |
| AST_SCANTYPE | AST scanners to use e.g., sast,sca,kics |
| SAST_SCAN_PRESET | SAST scan preset e.g., Checkmarx Default |
| REPORT_FORMAT | Report format e.g., json, summaryHTML, sarif, summaryConsole |
| PARAMS | Additional CxAST CLI parameters to add|

## References
AST-CLI [[1]]  
CxAST CLI KC [[2]]  
AST-CLI Docker [[3]]  

[1]: https://github.com/Checkmarx/ast-cli "AST-CLI"
[2]: https://checkmarx.atlassian.net/wiki/spaces/AST/pages/2445443121/CLI+Tool "CxAST CLI KC"
[3]: https://hub.docker.com/r/checkmarx/ast-cli "AST-CLI docker"