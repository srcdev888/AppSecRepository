@echo off
REM Version 0.4
set PRESET="Checkmarx Default"
set EXCLUDE=test_CX
set PROJECTNAME=%CI_PROJECT_NAME%
set TEAM=CxServer
set WORKSPACE=%CI_PROJECT_DIR%
set OSASCAN=
set temp=%WINDIR%\TEMP
set tmp=%WINDIR%\TEMP
set HIGH_VULNERABILITY_THRESHOLD=10000
set MEDIUM_VULNERABILITY_THRESHOLD=100000

:initial
if [%1]==[-p] goto  lpresetname
if [%1]==[-e] goto  lexcludename
if [%1]==[-h] goto  lhigh
if [%1]==[-m] goto  lmedium
if [%1]==[-o] goto  lEnableOsa
if [%1]==[-r] goto  lOsaReportPDF
if [%1]==[]   goto  main

shift
goto initial

:main
set USERNAME=admin
set PASSWORD=*********
echo %PASSWORD%

set Cx_PATH=CxServer
set CHECKMARX_HOST=http://localhost



rem It is recommended to add Java/bin and CxConsole folders in the PATH.
rem Path to CxConsole
set CX_CONSOLE_PATH=C:\CxDistributions\CxConsolePlugin-8.90.0

rem Path to Bamboo integration kit files; possibly separate from CxConsole
set CX_GitLab_PATH=C:\GitLab-Runner\GitLab

rem Set if not set already
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_144\jre

REM These can be set in Bambooo or here
IF not defined PRESET set PRESET="Checkmarx Default"
IF not defined JOB_NAME set JOB_NAME=%PROJECTNAME%@Gitlab

echo %WORKSPACE%

set CxResultXml=%WORKSPACE%\\%JOB_NAME%_CXresult.xml
set CxResultHtml=%WORKSPACE%\\%JOB_NAME%_CXresults.html
set CxResultPdf=%WORKSPACE%\\%JOB_NAME%_CXresults.pdf

rem set PATH=%JAVA_HOME%/bin;%PATH%
set CX_CONSOLE_CMD=%CX_CONSOLE_PATH%\runCxConsole.cmd
set MSXSL_PATH=%CX_GitLab_PATH%\msxsl.exe
set CxPARSER_PATH=%CX_GitLab_PATH%\CxCheckThresholds.bat
set XSLT_HTML_OUTPUT=%CX_GitLab_PATH%\CxResult.xslt
set CxParseXMLResults_PATH=%CX_GitLab_PATH%\CxParseXMLResults.exe
IF EXIST "%CxResultHtml%" del "%CxResultHtml%"
IF EXIST "%CxResultPdf%" del "%CxResultPdf%"
IF EXIST "%CxResultXml%" del "%CxResultXml%"

set CX_SCAN_CMD="%CX_CONSOLE_CMD%" Scan -Incremental -CxPassword %PASSWORD% -CxServer %CHECKMARX_HOST% -CxUser %USERNAME% -ProjectName %Cx_PATH%\%JOB_NAME% -Preset %PRESET% -LocationType folder -locationpath "%WORKSPACE%" -reportxml "%CxResultXml%" -reportpdf "%CxResultPdf%" -locationpathexclude "%EXCLUDE%" %OSASCAN% -v
echo %CX_SCAN_CMD%
CALL %CX_SCAN_CMD%
IF not errorlevel 0  exit /b %ERRORLEVEL%

echo.
set CX_XSL_CMD="%MSXSL_PATH%" "%CxResultXml%" "%XSLT_HTML_OUTPUT%" -o "%CxResultHtml%"
echo %CX_XSL_CMD%
IF EXIST "%CxResultXml%" CALL %CX_XSL_CMD%
set CX_PARSER_CMD="%CxPARSER_PATH%" "%CxResultXml%" %HIGH_VULNERABILITY_THRESHOLD% %MEDIUM_VULNERABILITY_THRESHOLD%
echo %CX_PARSER_CMD%
IF EXIST "%CxResultXml%" CALL %CX_PARSER_CMD%

echo.
echo ErrorLevel=%errorlevel%
goto finish


:lhigh
shift
echo set HIGH_VULNERABILITY_THRESHOLD=%1
set HIGH_VULNERABILITY_THRESHOLD=%1
shift
goto initial

:lmedium
shift
echo set MEDIUM_VULNERABILITY_THRESHOLD=%1
set MEDIUM_VULNERABILITY_THRESHOLD=%1
shift
goto initial

:lpresetname
shift
set PRESET=%1
shift
goto initial

:lexcludename
shift
set EXCLUDE=%EXCLUDE%,%1
shift
goto initial

:lEnableOsa
shift
ECHO Found -EnableOsa    
SET OSASCAN=-EnableOsa
goto initial


:finish
echo ErrorLevel=%errorlevel%
