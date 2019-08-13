# AD helper functions

. ".\utils.ps1"

# Remove AD Organization Unit
function Remove-ADOU {

    <#
        .SYNOPSIS
            Remove AD organization Unit
        .DESCRIPTION
            This function remove the AD Organization Unit recursively 
        .EXAMPLE
            Remove-ADOU -Identity "OU=Sites,DC=mycheckmarx,DC=com"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Identity
    )

    Remove-ADOrganizationalUnit -Identity $Identity -Recursive -Confirm:$False
}

# Create AD Organization Unit
function New-ADOU {

    <#
        .SYNOPSIS
            Create new AD organization Unit
        .DESCRIPTION
            This function create new AD Organization Unit 
        .EXAMPLE
            New-ADOU -Name "Sites" -Description "Sites" -Path "DC=mycheckmarx,DC=com"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Name,

        [Parameter()]
        [string] $Description,

        [Parameter(Mandatory=$true)]
        [string] $Path

    )
    New-ADOrganizationalUnit -Name $Name -Description $Description -Path $Path -ProtectedFromAccidentalDeletion $false
}

# Create AD Group
function New-ADGrp {

    <#
        .SYNOPSIS
            Create new AD Group
        .DESCRIPTION
            This function create new AD Group
        .EXAMPLE
            New-ADGrp -Name "Scanner-All" -Description "CX Scanner" -Path "OU=Sites, OU=APAC, DC=mycheckmarx,DC=com" -GroupCategory Security -GroupScope DomainLocal
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Name,

        [Parameter()]
        [string] $Description,

        [Parameter(Mandatory=$true)]
        [string] $Path,

        [Parameter()]
        [Microsoft.ActiveDirectory.Management.ADGroupCategory] $GroupCategory,

        [Parameter()]
        [Microsoft.ActiveDirectory.Management.ADGroupScope] $GroupScope


    )
    New-ADGroup -Name $Name -Description $Description -Path $Path -GroupCategory $GroupCategory -GroupScope $GroupScope -PassThru

}

# Create new user properties
function New-ADUsrProp {

    <#
        .SYNOPSIS
            Create User Property
        .DESCRIPTION
            This function create user property using the New-RandomUser returned from invoking utilities.ps1 
        .EXAMPLE
            New-ADUsrProp -user $user -Path "OU=Sites, OU=APAC, DC=mycheckmarx,DC=com" -fulldomain "checkmarx.com" -userPassword 'Cx!123456'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $user,

        [Parameter(Mandatory=$true)]
        [string] $Path,

        [Parameter(Mandatory=$true)]
        [string] $fulldomain,

        [Parameter(Mandatory=$true)]
        [string] $userPassword
        
    )
    return @{
        Name = "$($user.name.first) $($user.name.last)"
        City = "$S"
        GivenName = $user.name.first
        Surname = $user.name.last
        Path = $Path
        OfficePhone = $user.phone
        MobilePhone = $user.cell
        EmailAddress="$($user.name.first).$($user.name.last)@$($fulldomain)"
        AccountPassword = (ConvertTo-SecureString $userPassword -AsPlainText -Force)
        SamAccountName = $($user.name.first).Substring(0,1)+$($user.name.last)
        UserPrincipalName = "$(($user.name.first).Substring(0,1)+$($user.name.last))@$($fulldomain)"
        Enabled = $true
    }
}


# Create AD user
function New-ADUsr {

    <#
        .SYNOPSIS
            Create New AD user
        .DESCRIPTION
            This function create new AD user using the array New-ADUsrProp  
        .EXAMPLE
            New-ADUsr $newUserProperties
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $newUserProperties
    )
    
    #Write-Output $newUserProperties
    New-ADUser @newUserProperties -verbose
}

# Create AD Group member
function Add-ADGrpMember {

    <#
        .SYNOPSIS
            Add AD group member
        .DESCRIPTION
            This function add user to group using the array New-ADUsrProp  
        .EXAMPLE
            Add-ADGrpMember -Identity "CN=Scanner-All, OU=Sites, OU=APAC, DC=mycheckmarx,DC=com" -newUserProperties $newUserProperties
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Identity,
        
        [Parameter(Mandatory=$true)]
        [array]$newUserProperties
    )
    Add-ADGroupMember -Identity $Identity -Members $newUserProperties.SamAccountName
}

<#
New-ADOU -Name "Test" -Description "Sites" -Path "DC=mycheckmarx,DC=com"
$Users = New-RandomUser -Amount 2 -Nationality sg,in -IncludeFields name,dob,phone,cell -ExcludeFields picture | Select-Object -ExpandProperty results
foreach ($user in $Users) {
    $newUserProperties = New-ADUsrProp -user $user -Path "OU=Test, DC=mycheckmarx,DC=com" -fulldomain "checkmarx.com" -userPassword 'Cx!123456'
    New-ADUsr $newUserProperties
    #Add-ADGrpMember -Identity "CN=Scanner-All, OU=Sites, OU=APAC, DC=mycheckmarx,DC=com" -newUserProperties $newUserProperties
}
#>