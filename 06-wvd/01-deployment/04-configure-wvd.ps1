###########################################
#    Install PowerShell Module for WVD    #
###########################################
$Module = 'Microsoft.RDInfra.RDPowerShell'
if((Test-Path -Path "C:\Program Files\WindowsPowerShell\Modules\$Module" -ErrorAction SilentlyContinue)-eq $true) 
{
    if((Get-Module -Name $Module -ErrorAction SilentlyContinue) -eq $false) 
    {
        Write-Host -ForegroundColor Cyan -BackgroundColor Black "Importing Module"        
        Import-Module -Name $Module -Verbose -ErrorAction SilentlyContinue
    }
    Else 
    {
        Write-Host -ForegroundColor Yellow -BackgroundColor Black "Module already imported"        
    }
}
else 
{
    Install-Module -Name $Module -Force -Verbose -ErrorAction Stop    
}

##Variables
$aadDirectoryID = "ab39cb4a-bab2-4bac-b234-31f6c900a46a"
$subID = "949ef534-07f5-4138-8b79-aae16a71310c"

##creating RDS Tenant
##variables
$rdsTenantName = "flkellyintwvdtenenat1"
$rdsOwner = "ironman@flkellyinternal.onmicrosoft.com"
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"
New-RdsTenant -Name $rdsTenantName -AadTenantId $aadDirectoryID -AzureSubscriptionId $subID
New-RdsRoleAssignment -TenantName $rdsTenantName -SignInName $rdsOwner  -RoleDefinitionName "RDS Owner"

##creating ServicePrincipal
Install-Module AzureAD
$aadContext = Connect-AzureAD
$svcPrincipal = New-AzureADApplication -AvailableToOtherTenants $true -DisplayName "Windows Virtual Desktop Svc Principal"
$svcPrincipalCreds = New-AzureADApplicationPasswordCredential -ObjectId $svcPrincipal.ObjectId

$filepath = $env:USERPROFILE +"\Desktop\wvdinfo1.txt"
Add-Content -Path $filepath -Value "SPN Creds: $svcPrincipalCreds.Value"
$svcPrincipalCreds.Value
Add-Content -Path $filepath -Value "Tanant ID GUID:  $aadContext.TenantId.Guid"
$aadContext.TenantId.Guid
Add-Content -Path $filepath -Value "SPN App ID:  $svcPrincipal.AppId"
$svcPrincipal.AppId
Write-host "Please check this file $filepath for all your required info"

Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"
Get-RdsTenant

##adding SPN to required group
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -ApplicationId $svcPrincipal.AppId -TenantName $rdsTenantName
$creds = New-Object System.Management.Automation.PSCredential($svcPrincipal.AppId, (ConvertTo-SecureString $svcPrincipalCreds.Value -AsPlainText -Force))
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com" -Credential $creds -ServicePrincipal -AadTenantId $aadContext.TenantId.Guid

##create host pool
Start-Process 'https://docs.microsoft.com/en-us/azure/virtual-desktop/create-host-pools-azure-marketplace'

Write-host "Confirming you have completed the above step?"
$answer = Read-Host "[Y]es or [N]o"

while("y","Y","yes","YES","n","N","no","NO" -notcontains $answer)
{
	$answer = Read-Host "[Y]es or [N]o"
} 

##adding more users to the desktop application group
$rdsUsers = "warmachine@flkellyinternal.onmicrosoft.com"
$rdsHostPool = "flkellypool1"
$rdsAppGroupName = "Desktop Application Group"
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"
## To list all pools
Get-RdsHostPool -TenantName $rdsTenantName
Get-RdsAppGroup -TenantName $rdsTenantName -HostPoolName $rdsHostPool
Add-RdsAppGroupUser $rdsTenantName $rdsHostPool $rdsAppGroupName -UserPrincipalName $rdsUsers

##remote app time
$rdsRemoteAppGroupName = "remote Apps"
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"
New-RdsAppGroup $rdsTenantName $rdsHostPool $rdsRemoteAppGroupName -ResourceType "RemoteApp"
Get-RdsAppGroup $rdsTenantName $rdsHostPool
##whats available
Get-RdsStartMenuApp $rdsTenantName $rdsHostPool $rdsRemoteAppGroupName
##using wordpad as an example
$appAlias = "wordpad"
$appName = "flkelly-wordpad"
New-RdsRemoteApp $rdsTenantName $rdsHostPool $rdsRemoteAppGroupName -Name $appName -AppAlias $appAlias
$wordpadRemoteApp = get-RdsRemoteApp $rdsTenantName $rdsHostPool $rdsRemoteAppGroupName -Name $appName
$value = "RemoteAppName: " + $wordpadRemoteApp.RemoteAppName
Add-Content -Path $filepath -Value $value
$value = "RemoteAppFilePath: " + $wordpadRemoteApp.FilePath
Add-Content -Path $filepath -Value $value
$value = "RemoteAppIconPath: " + $wordpadRemoteApp.IconPath
Add-Content -Path $filepath -Value $value
$value = "RemoteAppIconIndex: " + $wordpadRemoteApp.IconIndex
Add-Content -Path $filepath -Value $value
Write-host "Please check this file $filepath for all your required info"
New-RdsRemoteApp $rdsTenantName $rdsHostPool $rdsRemoteAppGroupName -Name $wordpadRemoteApp -Filepath $wordpadRemoteApp.FilePath -IconPath $wordpadRemoteApp.IconPath -IconIndex $wordpadRemoteApp.IconIndex
##confirm
Get-RdsRemoteApp $rdsTenantName $rdsHostPool $rdsRemoteAppGroupName

##grant permission to new app
Add-RdsAppGroupUser $rdsTenantName $rdsHostPool $rdsRemoteAppGroupName -UserPrincipalName blackwidow@flkellyinternal.onmicrosoft.com
Add-RdsAppGroupUser $rdsTenantName $rdsHostPool $rdsRemoteAppGroupName -UserPrincipalName thor@flkellyinternal.onmicrosoft.com