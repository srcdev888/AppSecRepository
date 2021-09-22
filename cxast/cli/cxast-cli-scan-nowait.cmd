@echo on

:: Sample on SAST, SCA & KICS scanning via CxAST CLI

pushd "%~dp0"

:: CxSAST CLI Properties
set CX_CONSOLE_CMD=.\CLI\cx.exe

:: Global Properties
set agent="MyASTCLI"
set apikey=""
set base_auth_uri="https://eu.iam.checkmarx.net/"
set base_url="https://eu.ast.checkmarx.net/"
set tenant=""
set verbose=-v
set cli_args=%verbose% --agent %agent% --apikey %apikey% --base-auth-uri %base_auth_uri% --base-uri %base_url% --tenant %tenant%

:: Project Properties
set projectName="JavaVulnerableLab"
:: See https://checkmarx.atlassian.net/wiki/spaces/SAST/pages/3206503730/Predefined+Presets
set preset="ASA Premium"
set scantype="sast,sca,kics"
set cli_args=%cli_args% --project-name %projectName% --sast-preset-name %preset% --scan-types %scantype% --nowait

:: Pull source code from git
set GitURL=https://github.com/CSPF-Founder/JavaVulnerableLab.git
set filesource=%cd%\JavaVulnerableLab
set branch="master"
git clone --branch %branch% %GitURL% %filesource%

:: Execute Scans
set file_include=Dockerfile
set file_filter="!.git"
set cli_args=%cli_args% --file-include %file_include% --file-source %filesource% --file-filter %file_filter% --branch %branch%

:: Execute SAST Scan 
CALL %CX_CONSOLE_CMD% scan create %cli_args%

RMDIR /s /q %filesource%

set exitCode=%errorlevel%

popd
Exit /B %exitCode%