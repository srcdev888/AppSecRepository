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

param([Parameter(Mandatory=$true, HelpMessage="Create or Remove")][ValidateSet(“Create”,”Remove")][string]$Action)

. ".\utils-ad.ps1"

# Domain Names
$fqdn = Get-ADDomain
$fulldomain = $fqdn.DNSRoot
$domain = $fulldomain.split(".")
$Dom = $domain[0]
$Ext = $domain[1]

# Organization Units
$Sites = ("APAC","EMEA","US")
$Services = ("RND","DevOps","Security")
$FirstOU ="Sites"

# Group
$Groups = ("Scanner-All", "Scanner-NE", "Scanner-DEL", "Scanner-None", "Reviewer-All", "Reviewer-None")

# Number of users per service OU
$Amount = 1
$userPassword = 'Cx!123456'

function Remove-MyLab {

    #Remove-ADOrganizationalUnit -Identity "" -Recursive -Confirm:$False
    Remove-ADOU -Identity "OU=$FirstOU,DC=$Dom,DC=$EXT"
}

function New-MyLab {
    
    #New-ADOrganizationalUnit -Name $FirstOU -Description $FirstOU -Path "DC=$Dom,DC=$EXT" -ProtectedFromAccidentalDeletion $false
    New-ADOU -Name $FirstOU -Description $FirstOU -Path "DC=$Dom,DC=$EXT"

    foreach  ($S in $Sites)
    {
        #New-ADOrganizationalUnit -Name $S -Description "$S"  -Path "OU=$FirstOU,DC=$Dom,DC=$EXT" -ProtectedFromAccidentalDeletion $false
        New-ADOU -Name $S -Description "$S" -Path "OU=$FirstOU,DC=$Dom,DC=$EXT"
       

        foreach ($Serv in $Services)
        {
            #New-ADOrganizationalUnit -Name $Serv -Description "$S $Serv"  -Path "OU=$S,OU=$FirstOU,DC=$Dom,DC=$EXT" -ProtectedFromAccidentalDeletion $false
            New-ADOU -Name $Serv -Description "$S" -Path "OU=$S,OU=$FirstOU,DC=$Dom,DC=$EXT"

            foreach ($Grp in $Groups){
                
                #New-ADGroup -Name "$S-$Serv-$Grp" -Description "$S $Serv $Grp" -Path "OU=$S,OU=$FirstOU,DC=$Dom,DC=$EXT" -GroupCategory Security -GroupScope DomainLocal -PassThru
                New-ADGrp -Name "$S-$Serv-$Grp" -Description "$S $Serv $Grp" -Path "OU=$S,OU=$FirstOU,DC=$Dom,DC=$EXT" -GroupCategory Security -GroupScope DomainLocal

                switch ($S)
                {
                    'APAC' {
                                $Users = New-RandomUser -Amount $Amount -Nationality sg,in -IncludeFields name,dob,phone,cell -ExcludeFields picture | Select-Object -ExpandProperty results
                            }
                    'EMEA' {
                                $Users = New-RandomUser -Amount $Amount -Nationality il,es -IncludeFields name,dob,phone,cell -ExcludeFields picture | Select-Object -ExpandProperty results
                            }
                    'US' {
                                $Users = New-RandomUser -Amount $Amount -Nationality us -IncludeFields name,dob,phone,cell -ExcludeFields picture | Select-Object -ExpandProperty results
                            }
                    Default {}
                }
            
                foreach ($user in $Users)
                {
                    <#
                        $newUserProperties = @{
                            Name = "$($user.name.first) $($user.name.last)"
                            City = "$S"
                            GivenName = $user.name.first
                            Surname = $user.name.last
                            Path = "OU=$Serv,OU=$S,OU=$FirstOU,dc=$Dom,dc=$EXT"
                            title = "Employees"
                            department="$Serv"
                            OfficePhone = $user.phone
                            MobilePhone = $user.cell
                            Company="$Dom"
                            EmailAddress="$($user.name.first).$($user.name.last)@$($fulldomain)"
                            AccountPassword = (ConvertTo-SecureString $userPassword -AsPlainText -Force)
                            SamAccountName = $($user.name.first).Substring(0,1)+$($user.name.last)
                            UserPrincipalName = "$(($user.name.first).Substring(0,1)+$($user.name.last))@$($fulldomain)"
                            Enabled = $true
                        }
                    #>
                    $newUserProperties = New-ADUsrProp -user $user -Path "OU=$Serv,OU=$S,OU=$FirstOU,dc=$Dom,dc=$EXT" -fulldomain $fulldomain -userPassword $userPassword
                    
                    Try{
                     
                        # New-ADUser @newUserProperties
                        New-ADUsr $newUserProperties
                        

                        #Add-ADGroupMember -Identity "CN=$S-$Serv-$Grp,OU=$S,OU=$FirstOU,DC=$Dom,DC=$EXT" -Members $newUserProperties.SamAccountName
                        Add-ADGrpMember -Identity "CN=$S-$Serv-$Grp,OU=$S,OU=$FirstOU,DC=$Dom,DC=$EXT" -newUserProperties $newUserProperties

                    } catch{}
                }
            }
        }
    }

}

switch ($Action)
{
    'Create' {
                New-MyLab
             }
    'Remove' {
                Remove-MyLab
             }
    Default  {}

}

#Get-ADUser -Filter * -SearchBase "OU=Sites,DC=mycheckmarx,DC=com"