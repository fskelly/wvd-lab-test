Import-Module ActiveDirectory
$domainName = (Get-ADDomain).dnsroot
$ou = "WVDUsers"
$domainRoot = (Get-ADRootDSE).defaultNamingContext
New-ADOrganizationalUnit -Name $ou -Path $domainRoot -ProtectedFromAccidentalDeletion $False
$wvdOU = Get-ADOrganizationalUnit -filter 'Name -like $OU'
$users = "thor", "hulk", "ironman", "hawkeye", "blackwidow", "captainamerica", "starlord", "rocket", "warmachine"
foreach ($user in $users)
{
    New-AdUser -Name $user -Path $wvdOU.DistinguishedName -Enabled $true -ChangePasswordAtLogon $false -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -force) -passThru
}

##domain join user
$domainJoinUserName = "domainjoin"
New-AdUser -Name $domainJoinUserName  -Enabled $true -ChangePasswordAtLogon $false -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -force) -passThru
