<#
.SYNOPSIS
    Lab script to add nested OUs, random Groups and Users in Active Directory

.DESCRIPTION
    Edit the files;
    - Nested OUs {FirstOU, Sites, Services}
    - Groups {Groups}
    - Number of users per service OU {Amount}
    - User password {$userPassword}

.PARAMETER Action 
    Specifies the script action. 'Create' to build, 'Remove' to delete 

.EXAMPLE
    PS> AD-Lab -Action "Create"

.EXAMPLE
    PS> AD-Lab -Action "Delete"

.LINK
    https://jm2k69.github.io/2018-10-22-Active-Directory-PowerShell/#32-create-one-ou

#>

$ServerInstance="WIN-5LEQ7ISE2JO\SQLEXPRESS"


$insertquery=" 
INSERT INTO [dbo].[ServiceTable] 
           ([Status] 
           ,[Name] 
           ,[DisplayName]) 
     VALUES 
           ('$ser' 
           ,'$name' 
           ,'$disname') 
GO 
"
 
Invoke-SQLcmd -ServerInstance $ServerInstance -query $insertquery -U sa -P test123 -Database Fantasy 

Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery;" -ServerInstance "WIN-5LEQ7ISE2JO\SQLEXPRESS"
 
