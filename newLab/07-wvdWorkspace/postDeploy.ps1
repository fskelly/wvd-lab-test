$rgName = "flkelly-wus-wvd-arm"
$hostPoolName = "fktest-1"
New-AzWvdRegistrationInfo -ResourceGroupName $rgName -HostPoolName $hostPoolName -ExpirationTime $((get-date).ToUniversalTime().AddDays(1).ToString('yyyy-MM-ddTHH:mm:ss.fffffffZ'))

##add user to the default Desktop APP Group
$dag = $hostPoolName + "-DAG"
$dagUPNs = "wvdUser1@fskelly.com", "wvdUser2@fskelly.com", "wvdUser3@fskelly.com", "wvdUser4@fskelly.com"
foreach ($user in $dagUPNs)
{
    New-AzRoleAssignment -SignInName $user -RoleDefinitionName "Desktop Virtualization User" -ResourceName $dag -ResourceGroupName $rgName -ResourceType 'Microsoft.DesktopVirtualization/applicationGroups'
}

##add AAD Group to the default Desktop APP Group
$dag = $hostPoolName + "-DAG"
$dagAADGroups = "",""
foreach ($group in $dagAADGroups)
{
    New-AzRoleAssignment -ObjectId $group -RoleDefinitionName "Desktop Virtualization User" -ResourceName $dag -ResourceGroupName $rgName -ResourceType 'Microsoft.DesktopVirtualization/applicationGroups'
}

## Get wvd registration token
$token = Get-AzWvdRegistrationInfo -ResourceGroupName $rgName -HostPoolName $hostPoolName