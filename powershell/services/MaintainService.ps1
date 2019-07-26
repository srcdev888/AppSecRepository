<#

Author: Khoa Nguyen
PS C:\Users\KoA\Dropbox\Code-Store\powershell> $PSVersionTable.PSVersion

Major  Minor  Build  Revision
-----  -----  -----  --------
5      1      15063  608

This is a quick script to start, stop and restart a service. The script will validate that
the service exists and the required action parameter (stop, start, restart) is valid prior
to executing the script.

Sample Executions:

PS C:\Users\KoA\Dropbox\Code-Store\powershell> .\MaintainService.ps1 Spooler Start
Spooler is stopped, preparing to start...
Spooler - Running
PS C:\Users\KoA\Dropbox\Code-Store\powershell> .\MaintainService.ps1 Spooler Stop
Spooler is running, preparing to stop...
Spooler - Stopped
PS C:\Users\KoA\Dropbox\Code-Store\powershell> .\MaintainService.ps1 FakeService Start
FakeService not found
PS C:\Users\KoA\Dropbox\Code-Store\powershell> .\MaintainService.ps1 FakeService Stop
FakeService not found
PS C:\Users\KoA\Dropbox\Code-Store\powershell> .\MaintainService.ps1 Spooler Start
Spooler is stopped, preparing to start...
Spooler - Running
PS C:\Users\KoA\Dropbox\Code-Store\powershell> .\MaintainService.ps1 Spooler Restart
Spooler is running, preparing to restart...
Spooler - Running
PS C:\Users\KoA\Dropbox\Code-Store\powershell> .\MaintainService.ps1 Spooler Stop
Spooler is running, preparing to stop...
Spooler - Stopped
PS C:\Users\KoA\Dropbox\Code-Store\powershell> .\MaintainService.ps1 Spooler Restart
Spooler is stopped, preparing to start...
Spooler - Running
PS C:\Users\KoA\Dropbox\Code-Store\powershell> .\MaintainService.ps1 Spooler Check
Action parameter is missing or invalid!
PS C:\Users\KoA\Dropbox\Code-Store\powershell> .\MaintainService.ps1 FakeService Check
FakeService not found
PS C:\Users\KoA\Dropbox\Code-Store\powershell>

#>

param (
[Parameter(Mandatory=$true)]
[string] $ServiceName,
[string] $Action
)

#Checks if ServiceName exists and provides ServiceStatus
function CheckMyService ($ServiceName)
{
	if (Get-Service $ServiceName -ErrorAction SilentlyContinue)
	{
		$ServiceStatus = (Get-Service -Name $ServiceName).Status
		Write-Host $ServiceName "-" $ServiceStatus
	}
	else
	{
		Write-Host "$ServiceName not found"
	}
}

#Checks if service exists
if (Get-Service $ServiceName -ErrorAction SilentlyContinue)
{	#Condition if user wants to stop a service
	if ($Action -eq 'Stop')
	{
		if ((Get-Service -Name $ServiceName).Status -eq 'Running')
		{
			Write-Host $ServiceName "is running, preparing to stop..."
			Get-Service -Name $ServiceName | Stop-Service -ErrorAction SilentlyContinue
			CheckMyService $ServiceName
		}
		elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped')
		{
			Write-Host $ServiceName "already stopped!"
		}
		else
		{
			Write-Host $ServiceName "-" $ServiceStatus
		}
	}

	#Condition if user wants to start a service
	elseif ($Action -eq 'Start')
	{
		if ((Get-Service -Name $ServiceName).Status -eq 'Running')
		{
			Write-Host $ServiceName "already running!"
		}
		elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped')
		{
			Write-Host $ServiceName "is stopped, preparing to start..."
			Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			CheckMyService $ServiceName
		}
		else
		{
			Write-Host $ServiceName "-" $ServiceStatus
		}
	}

	#Condition if user wants to restart a service
	elseif ($Action -eq 'Restart')
	{
		if ((Get-Service -Name $ServiceName).Status -eq 'Running')
		{
			Write-Host $ServiceName "is running, preparing to restart..."
			Get-Service -Name $ServiceName | Stop-Service -ErrorAction SilentlyContinue
			Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			CheckMyService $ServiceName
		}
		elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped')
		{
			Write-Host $ServiceName "is stopped, preparing to start..."
			Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			CheckMyService $ServiceName
		}
	}

	#Condition if action is anything other than stop, start, restart
	else
	{
		Write-Host "Action parameter is missing or invalid!"
	}
}

#Condition if provided ServiceName is invalid
else
{
	Write-Host "$ServiceName not found"
}