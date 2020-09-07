
<# 
 .Synopsis
    Prepare to deploy Windows Virtual Desktop Environment

 .Description
    Install WVD PowerShell Modules, 
    Create WVD Resources:
        WVD Tenant, 
        HostPool, 
        WVD Permissions,
        First App Group,
        App Group Permissions

 .Parameter AADTenantID
    Azure Active Directory Tenant ID
        AAD Portal, Properties Copy ID

 .Parameter SubscriptionID
    Azure Subscription ID 

 .Parameter AzureADGlobalAdmin
    Azure AD Global Admin user name

 .Parameter AzureADDomainName
    Azure AD Domain Name, i.e. MSAzureAcademy.com

 .Parameter WVDTenantName
    Name of the Windows Virtual Desktop Tenant

 .Parameter WVDTenantGroup
    Tenant Group name, by default the first group is called ''

 .Parameter WVDHostPoolName
    Name of the Windows Virtual Desktop Host Pool

 .Parameter FirstAppGroupName
    Enter the name of the App Group for your Remote Applications

 .Example    
     # Create new Windows Virtual Desktop Deployment
    New-AzureWVDPrep `
        -AADTenantID xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx `
        -SubscriptionID 00000000-0000-0000-0000-000000000000 `
        -AzureADGlobalAdmin WVDAdmin `
        -AzureADDomainName MSAzureAcademy.com `
        -WVDTenantName MSAA-Tenant `
        -WVDTenantGroup 'Default Tenant Group' `
        -WVDHostPoolName MSAA-HostPool

#>



Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "Insufficient permissions to run this script. Open the PowerShell console as an administrator and run this script again."
Break
}
else 
{
Write-Host "Code is running as administrator — go on executing the script..." -ForegroundColor Green


###########################
#    General Variables    #
###########################                 
$AADTenantID = 'ab39cb4a-bab2-4bac-b234-31f6c900a46a'
$SubscriptionID = '949ef534-07f5-4138-8b79-aae16a71310c'
$WVDTenantName = 'flkelly-wvd-Tenant'
$WVDTenantGroup = 'Default Tenant Group'  ### DO NOT CHANGE
$WVDHostPoolName = 'flkelly-wvd-HostPool'
$FirstAppGroupName = 'flkelly-WVD'
$AzureADGlobalAdmin = 'groot'
$AzureADDomainName = 'flkellyinternal.onmicrosoft.com'
$FQDN = "$AzureADGlobalAdmin@$AzureADDomainName"


###########################################
#    Install PowerShell Module for WVD    #
###########################################
$Module = 'Microsoft.RDInfra.RDPowerShell'
if((Test-Path -Path "C:\Program Files\WindowsPowerShell\Modules\$Module" -ErrorAction SilentlyContinue)-eq $true) {
        if((Get-Module -Name $Module -ErrorAction SilentlyContinue) -eq $false) {
            Write-Host `
                -ForegroundColor Cyan `
                -BackgroundColor Black `
                "Importing Module"        
            Import-Module -Name $Module -Verbose -ErrorAction SilentlyContinue

        }
        Else {
            Write-Host `
                -ForegroundColor Yellow `
                -BackgroundColor Black `
                "Module already imported"        
        }
    }
else {
        Install-Module -Name $Module -Force -Verbose -ErrorAction Stop    
    }
Add-RdsAccount `
    -DeploymentUrl “https://rdbroker.wvd.microsoft.com”


###############################
#    Create New WVD Tenant    #
###############################
New-RDSTenant `
    -Name $WVDTenantName `
    -AadTenantId $AADTenantID `
    -AzureSubscriptionId $SubscriptionID 
New-RdsHostPool `
    -TenantName $WVDTenantName `
    -Name $WVDHostPoolName `
    -FriendlyName $WVDHostPoolName
New-RdsRoleAssignment `
    -RoleDefinitionName 'RDS Owner' `
    -SignInName $FQDN `
    -TenantGroupName $WVDTenantGroup `
    -TenantName $WVDTenantName `
    -HostPoolName $WVDHostPoolName `
    -AADTenantId $AADTenantID `
    -AppGroupName 'Desktop Application Group' `
    -Verbose


#######################################
#    Create New Application Groups    #
#######################################
New-RdsAppGroup `
    -TenantName $WVDTenantName `
    -HostPoolName $WVDHostPoolName `
    -Name $FirstAppGroupName `
    -ResourceType RemoteApp `
    -Verbose
Add-RdsAppGroupUser `
    -TenantName $WVDTenantName `
    -HostPoolName $WVDHostPoolName `
    -UserPrincipalName $FQDN `
    -AppGroupName $FirstAppGroupName   
}