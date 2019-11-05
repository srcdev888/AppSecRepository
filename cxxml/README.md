# Parsing Results in CxXML Report
* Author:   Pedric Kng  
* Updated:  05 Nov 2019

As part of integration into CI pipeline with Checkmarx, there is a need to retrieve certain statistics to determine next step e.g., failed/flag build, notifications.

Checkmarx offers plugin/CLI to execute scans, whereby XML report can be retrieved; note that this is possible only with synchronous scan.
The CX XML report offers many important statistics on each result e.g., result status, state, severity, code snippets, query information.

The purpose of this article is to share an example on how to extract values from CX XML report, whereby such values can be used to aid in CI pipeline decision making.

***
## Overview
We will walkthrough an example[[1]] based on Gitlab CI, where the pipeline workflow is;

1. Execute checkmarx scan and download the XML report
2. Should scan be successful, parse XML report and failed pipeline upon;
 - New result is reported (key: $status_new)
 - Exist result that have not been reviewed (key: $to_verify); Flag as 'To verify'

## Pre-requisites and Dependencies
The example has namely several pre-requisites and dependencies;  
1. [Powershell](#Powershell)
2. [Report parsing script](#Report-parsing-script)
3. [Result processing script](#Result-processing-script)

### Powershell
The example will use powershell scripts to parse the XML report, and in this will use a powershell docker image ['mcr.microsoft.com/powershell:latest'](https://hub.docker.com/_/microsoft-powershell) to process the results based on Linux Bash (Gitlab shared runner).

### Report parsing script
This project is dependent on a powershell script [parseXMLFile.PS1](parseXMLFile.PS1) to extract result details from the Checkmarx XML report.

```powershell
param([string]$resultsFile)
###### VARIABLES ######

$queries = New-Object System.Collections.ArrayList
$queriesResults = New-Object System.Collections.ArrayList
$languages = New-Object System.Collections.ArrayList
$highs = 0
$mediums = 0
$lows = 0
$infos = 0
$confirmed = 0
$not_exploitable = 0
$to_verify = 0
$high_to_verify = 0
$medium_to_verify = 0
$low_to_verify = 0
$info_to_verify = 0
$status_new = 0
$status_recurrent = 0

###### READ/PARSE FILE ######

[xml]$fileXmlContent = Get-Content $resultsFile
$nodes = $fileXmlContent.CxXMLResults
$attrs = $nodes.Attributes

###### Get Scan Config ######
$initiator = $attrs["InitiatorName"].Value
$owner = $attrs["Owner"].Value
$preset = $attrs["Preset"].Value
$projectName = $attrs["ProjectName"].Value
$projectId = $attrs["ProjectId"].Value
$teamFull = $attrs["TeamFullPathOnReportDate"].Value
$teamShort = $attrs["Team"].Value
$loc = $attrs["LinesOfCodeScanned"].Value
$files = $attrs["FilesScanned"].Value
$cxVersion = $attrs["CheckmarxVersion"].Value

$scanId = $attrs["ScanId"].Value
$scanLink = $attrs["DeepLink"].Value
$scanComments = $attrs["ScanComments"].Value
$scanType = $attrs["ScanType"].Value
$sourceOrigin = $attrs["SourceOrigin"].Value
$scanStart = $attrs["ScanStart"].Value

$reportCreationTime = $attrs["ReportCreationTime"].Value

$description = "Scan Link : " + $scanLink +
               "`nProject Name : " + $projectName +
               "`nProject ID : "  + $projectId +
               "`nPreset : "  + $preset +
               "`nLOC : "  + $loc +
               "`nFiles Count : "  + $files +
               "`nCX Version : "  + $cxVersion +
               "`nTeam : "  + $teamFull +
               "`nOwner : "  + $owner +
               "`n`nInitiator : "  + $initiator +
               "`nScan ID : "  + $scanId +
               "`nScan Type : "  + $scanType +
               "`nScan Comments : "  + $scanComments +
               "`nSource Origin : "  + $sourceOrigin +
               "`nScan Start : "  + $scanStart +
               "`nReport Creation Date : "  + $reportCreationTime

###### Get Scan Details (Results, Languages, Queries) ######
foreach($node in $nodes.ChildNodes){
    foreach($result in $node.ChildNodes){

        $state = $result.Attributes["state"].Value
        if($state.equals("0")){
            $to_verify++
        } elseif($state.equals("1")){
            $not_exploitable++
        } elseif($state.equals("2")){
            $confirmed++
        }

        $severity = $result.Attributes["Severity"].Value
        if($severity.equals("High")){
            $highs++
            if($state.equals("0")){
                $high_to_verify++
            }
        } elseif($severity.equals("Medium")){
            $mediums++
            if($state.equals("0")){
                $medium_to_verify++
            }
        } elseif($severity.equals("Low")){
            $lows++
            if($state.equals("0")){
                $low_to_verify++
            }
        } elseif($severity.equals("Information")){
            $infos++
            if($state.equals("0")){
                $info_to_verify++
            }
        }

        $status = $result.Attributes["Status"].Value
        if($status.equals("New")){
            $status_new++
        } elseif($status.equals("Recurrent")){
            $status_recurrent++
        }
    }

    $lang = $node.Attributes["Language"].Value

    if(!$languages.Contains($lang)){
        $languages.Add($lang) > $null
    }
    $queries.Add($node.Attributes["name"].Value) > $null
    $queriesResults.Add($node.ChildNodes.Count) > $null
}

###### Get Languages ######
$description = $description + "`n`nLanguages ("+ $languages.Count + ") : "
foreach($language in $languages){
    $description = $description + "`n" + $language
}

###### Get Results ######
$total = $highs + $mediums + $lows + $infos
$description = $description +
                "`n`nResults (" + $total + ") : " +
                "`n`nNew : " + $status_new +
                "`nRecurrent : " + $status_recurrent +
                "`n`nHigh : " + $highs +
                "`nMedium : " + $mediums +
                "`nLow : " + $lows +
                "`nInfo : " + $infos +
                "`n`nConfirmed : " + $confirmed +
                "`nTo Verify : " + $to_verify +
                "`nNot Exploitable : " + $not_exploitable +
                "`n`nHigh : " + $high_to_verify +
                "`nMedium : " + $medium_to_verify +
                "`nLow : " + $low_to_verify +
                "`nInfo : " + $info_to_verify +
                "`n`nQueries ("+$queries.Count+") : "

###### Get Queries ######
For($i=0; $i -le $queries.Count - 1; $i++) {
    $description = $description + "`n" + $queries[$i] + " (" + $queriesResults[$i] + ")"
}

###### Majority of APIs does not accept punctuation ######
Function Remove-Diacritics ($sToModify){
  foreach ($s in $sToModify){
    if ($sToModify -eq $null) {
        return [string]::Empty
    }
    $sNormalized = $sToModify.Normalize("FormD")

    foreach ($c in [Char[]]$sNormalized){
      $uCategory = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c)
      if ($uCategory -ne "NonSpacingMark") {
        $res += $c
      }
    }
    return $res
  }
}

$description = Remove-Diacritics $description
$summary = "New Checkmarx Scan - ${projectName} - ${scanId}"
return @($status_new, $status_recurrent, $highs, $mediums, $lows, $to_verify, $summary, $description, $scanLink)
```
The script summarizes and returns

| Output        | Key            | Description  |
| ------------- |:-------------|:-----|
| New      | $status_new | Number of new issues found |
| Recurrent      | $status_recurrent      | Number of recurrent issues found |
| Highs | $highs    |    Number of high issues found |
| Mediums | $mediums     |    Number of medium issues found |
| Lows | $lows     |    Number of low issues found |
| To Verify | $to_verify | Number of issues with 'To Verify' state |
| Summary | $summary      |  Scan summary   |
| Description | $description      | Result Description |
| ScanLink | $scanLink     | Project URL link to Checkmarx portal |

### Result processing script
This example also requires another powershell script [gitlabexample.PS1](gitlabexample.PS1) has to execute the report parsing script in Gitlab CI, process returned findings and determine the condition to pass or fail the pipeline accordingly.

```Powershell
#! /usr/bin/pwsh

param([string]$resultsFile)
echo $PSVersionTable
$results = & "~/.././parseXMLFile.PS1" "$resultsFile"
If( $results[0] -ne '0' -or $results[5] -ne '0') {
    Write-Host "Error: New vulnerability or Non-reviewed results found"
    Exit 1
}
```
** Note: Powershell working in bash container requires specifying the powershell executable in the header, this can be found via this command
```Bash
>> which pwsh
```
** Note: Should the powershell script execution failed, please check the PS Version
```Powershell
>> echo $PSVersionTable
```


## Integration into Gitlab CI
Gitlab CI pipeline is described via .gitlab-ci.yml included in the project sources, a simple 3 stages pipeline is described below;
1. build - Compile and build project
2. test - Execute checkmarx SAST scan and download XML report
3. post-test - Parse XML report and determine to fail/pass pipeline

The example yml is listed below, or in the [Example repository](https://gitlab.com/cxdemosg/dvja/blob/checkmarx-test/.gitlab-ci.yml);

```yml
default:
  image: maven:latest

stages:
  - build
  - test
  - post-test

build:
  stage: build
  script:
    - mvn package

checkmarx-test:
  stage: test
  image: java:8
  before_script:
    - wget -O ~/../cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip
    - unzip ~/../cxcli.zip -d ~/../cxcli
    - chmod +x ~/../cxcli/runCxConsole.sh
  script:
    - ~/../cxcli/runCxConsole.sh Scan -CxServer "$CX_SERVER" -CxUser "$CX_USER" -CxPassword "$CX_PASSWORD" -ProjectName "$CX_TEAM\\$CI_PROJECT_NAME-$CI_COMMIT_REF_NAME" -preset "$CX_PRESET" -LocationType folder -LocationPath $CI_PROJECT_DIR -ReportXML $CI_PROJECT_DIR/results-$CI_PROJECT_NAME-$CI_COMMIT_REF_NAME.xml -ReportPDF $CI_PROJECT_DIR/results-$CI_PROJECT_NAME-$CI_COMMIT_REF_NAME.pdf -Comment "git $CI_COMMIT_REF_NAME@$CI_COMMIT_SHA" -verbose
  artifacts:
    name: "$CI_JOB_NAME-$CI_COMMIT_REF_NAME"
    expire_in: 1 day
    paths:
      - results-$CI_PROJECT_NAME-$CI_COMMIT_REF_NAME.pdf
      - results-$CI_PROJECT_NAME-$CI_COMMIT_REF_NAME.xml

checkmarx-xml:
  stage: post-test
  image: mcr.microsoft.com/powershell:latest
  variables:
   GIT_STRATEGY: none
   XML_REPORT: $CI_PROJECT_DIR/results-$CI_PROJECT_NAME-$CI_COMMIT_REF_NAME.xml
  before_script:
    - apt update && apt upgrade
    - apt-get -y install wget
    - wget -O ~/../parseXMLFile.PS1 https://raw.githubusercontent.com/cx-demo/MyAppSecRepository/master/cxxml/parseXMLFile.PS1
    - chmod +x ~/../parseXMLFile.PS1
    - wget -O ~/../gitlabexample.PS1 https://raw.githubusercontent.com/cx-demo/MyAppSecRepository/master/cxxml/gitlabexample.PS1
    - chmod +x ~/../gitlabexample.PS1
  script:
    - ~/.././gitlabexample.PS1 $XML_REPORT
```

## References
Gitlab CI example on parsing CX XML report [[1]]  

[1]:https://gitlab.com/cxdemosg/dvja "Example on parsing CX XML report with Gitlab CI"  
