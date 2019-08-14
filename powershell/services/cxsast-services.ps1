param([Parameter(Mandatory=$true, HelpMessage="Start, Stop or Restart")][ValidateSet('start','stop','restart')][string]$Action)


.\MaintainService.ps1 "World Wide Web Publishing Service" $Action
.\MaintainService.ps1 "IIS Admin Service" $Action

.\MaintainService.ps1 "ActiveMQ" $Action
.\MaintainService.ps1 "CxARM" $Action
.\MaintainService.ps1 "CxARMETL" $Action

.\MaintainService.ps1 "CxJobsManager" $Action
.\MaintainService.ps1 "CxScanEngine" $Action
.\MaintainService.ps1 "CxScansManager" $Action
.\MaintainService.ps1 "CxSystemManager" $Action