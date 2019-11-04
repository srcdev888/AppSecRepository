#! /usr/bin/pwsh

param([string]$resultsFile)

$ScriptPath = Split-Path $MyInvocation.InvocationName
echo $ScriptPath

$results = $ScriptPath/parseXMLFile.PS1 $resultsFile
If( $results[0] -ne '0' -or $results[5] -ne '0') {
    Write-Host "New vulnerability or Non-reviewed results found"
    Exit 1
}
