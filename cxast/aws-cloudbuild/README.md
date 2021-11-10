# Integrating AST scan in AWS CodeBuild

- Author: Pedric Kng
- Updated: 10 Nov 2021

This write-up describes the integration of CxAST scan via CLI mode into AWS CodeBuild

---

Add the [buildspec.yml](buildspec.yml) file to the root directory of your source code.

```yml
#buildspec.yml
version: 0.2

env:
  variables:
    AST_BASE_URL: "https://eu.ast.checkmarx.net/"
    AST_BASE_AUTH_URL: "https://eu.iam.checkmarx.net/"
    AST_AGENT: "AWSCodeBuild"
    AST_PROJECT_NAME: "JVL Demo"
    AST_PRESET: "Checkmarx Default"
    AST_SCANTYPE: "sast,sca,kics"
  parameter-store:
    AST_APIKEY: "/AST/APIKEY"
    AST_TENANT: "/AST/TENANT"
phases: 
  install: 
    runtime-versions: 
      java: corretto11
    commands:
      - echo Download CxAST CLI
      - CLI_VERSION=`wget -q "https://api.github.com/repos/Checkmarx/ast-cli/releases/latest" -O - | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`
      - wget -O ~/ast-cli.tar.gz "https://github.com/Checkmarx/ast-cli/releases/download/${CLI_VERSION}/ast-cli_${CLI_VERSION}_linux_x64.tar.gz"
      - tar -xzvf ~/ast-cli.tar.gz -C ~
      - rm -rf ~/ast-cli.tar.gz
      - chmod +x ~/cx
  pre_build:
    commands:
      - echo No pre-build stage
  build:
    commands:
      - echo Building JavaVulnerableLab Project 
      - cd $CODEBUILD_SRC_DIR
      - mvn install -Dmaven.compiler.source=1.6 -Dmaven.compiler.target=1.6
  post_build: 
    commands: 
      - ~/cx scan create --agent "$AST_AGENT" --apikey "$AST_APIKEY" --base-auth-uri "$AST_BASE_AUTH_URL" --base-uri "$AST_BASE_URL" --tenant "$AST_TENANT" --project-name "$AST_PROJECT_NAME" --sast-preset-name "$AST_PRESET" --scan-types "$AST_SCANTYPE" --file-source "$CODEBUILD_SRC_DIR" --branch "$CODEBUILD_SOURCE_VERSION"
```

The following are environment variables that is configured with the sample, do note that variables can be displayed in plain text using tools such as the AWS CodeBuild console.  

AWS offers a securestring variant 'Parameter' that is protected by the AWS System Manager Parameter store. It is recommended to protect sensitive values e.g., CxAST API Key with this mechanism. [[4]]

| Name                 | Type          | Description                          |
| -------------------- |---------------|--------------------------------------|
| AST_BASE_URL         | Plaintext     | CxAST URL                            |
| AST_BASE_AUTH_URL    | Plaintext     | CxAST Authentication URL             |
| AST_AGENT            | Plaintext     | CLI origin                           |
| AST_PROJECT_NAME     | Plaintext     | Project name                         |
| AST_PRESET           | Plaintext     | Scan Preset e.g., Checkmarx Default  |
| AST_SCANTYPE         | Plaintext     | Scan types e.g., SAST,SCA,KICS       |
| AST_TENANT           | Parameter     | CxAST Tenant name                    |
| AST_APIKEY           | Parameter     | CxAST API key [[5]]                  |

**Note** : Variable name starting with 'CODEBUILD_' are reserved for AWS CodeBuild internal use, they should not be used in your build commands


## References
AST-CLI [[1]]  
CxAST CLI KC [[2]]  
Build Specification Reference for AWS CodeBuild [[3]]  
Environment Variables in AWS CodeBuild [[4]]  
Generating an API Key [[5]]

[1]: https://github.com/Checkmarx/ast-cli "AST-CLI"
[2]: https://checkmarx.atlassian.net/wiki/spaces/AST/pages/2445443121/CLI+Tool "CxAST CLI KC"
[3]:https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html#build-spec-ref-syntax "Build Specification Reference for AWS CodeBuild"  
[4]:https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-env-vars.html "Environment Variables in CodeBuild"  
[5]:https://checkmarx.atlassian.net/wiki/spaces/AST/pages/5859574017/Generating+an+API+Key "Generating an API Key"