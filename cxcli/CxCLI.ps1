param (
    [Parameter(Mandatory, HelpMessage="cxserver")]
	[string]$cxserver,

    [Parameter(Mandatory, HelpMessage="cxtoken")]
	[string]$cxtoken,

    [Parameter(Mandatory, HelpMessage="projectname")]
	[string]$projectname,

    [Parameter(HelpMessage="preset, default=Checkmarx Default")]
	[string]$preset = "Checkmarx Default",

    [Parameter(Mandatory, HelpMessage="Build Location")]
	[string]$buildloc,

     [Parameter(Mandatory, HelpMessage="Comment")]
	[string]$comment
)

#URL for Checkmarx CLI Tool
$url = "https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.2.3.zip"

#name of the file
$zipfile = "CxConsolePlugin-2020.2.3.zip"
$dest = "CxConsolePlugin-2020.2.3"

#download file
(New-Object System.Net.WebClient).DownloadFile($url, $zipfile)

#unzip file provided in variable to script root
Expand-Archive $zipfile -Force

Write-Host "scanning with"
Write-Host "./runCxConsole.cmd scan -v -cxserver '$cxserver' -cxtoken '$cxtoken' -projectname '$projectname' -locationtype 'folder' -locationpath '$buildloc' -preset '$preset' -enableosa -executepackagedependency"

cd $dest

./runCxConsole.cmd scan -v -cxserver $cxserver -projectname $projectname -cxtoken $cxtoken -locationtype 'folder' -locationpath $buildloc  -preset $preset -enableosa -executepackagedependency -Comment $comment
