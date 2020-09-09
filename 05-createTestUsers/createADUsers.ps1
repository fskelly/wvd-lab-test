Import-Module ActiveDirectory
$ou = ""
$domainRoot = (Get-ADRootDSE).defaultNamingContext
New-ADOrganizationalUnit -Name $ou -Path $domainRoot -ProtectedFromAccidentalDeletion $False
$wvdOU = Get-ADOrganizationalUnit -filter 'Name -like $OU'
$users = "", "", "", "", "", "", "", "", ""
$password = ""
foreach ($user in $users)
{
    New-AdUser -Name $user -Path $wvdOU.DistinguishedName -Enabled $true -ChangePasswordAtLogon $false -AccountPassword (ConvertTo-SecureString $password -AsPlainText -force) -passThru
}

##domain join user
$domainJoinUserName = ""
$domainJoinUserPassword = ""
New-AdUser -Name $domainJoinUserName  -Enabled $true -ChangePasswordAtLogon $false -AccountPassword (ConvertTo-SecureString $domainJoinUserPassword -AsPlainText -force) -passThru
Add-ADGroupMember -Members (get-aduser -Identity $domainJoinUserName) -Identity (Get-ADGroup -Identity "Domain Admins")