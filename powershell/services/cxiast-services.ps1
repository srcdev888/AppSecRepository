param([Parameter(Mandatory=$true, HelpMessage="Start, Stop or Restart")][ValidateSet(“Start”,”Stop",”Restart")][string]$Action)


.\MaintainService.ps1 "CxAccessControl" $Action
.\MaintainService.ps1 "CxIAST_Demo" $Action
.\MaintainService.ps1 "CxIAST_Manager" $Action