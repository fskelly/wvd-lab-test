## create storage account
$location = ""
$resourceGroup = ""
$subid = ""
Select-AzSubscription -Subscription $subid

$storageType = "" ##filestorage for premium, StorageV2 for Standard
$sku = ""
$wvdStorageAccountName = ""
$wvdStorageAccount = new-azstorageaccount -kind $storageType -location $location -resourceGroup $resourceGroup -sku $sku -accountName $wvdStorageAccountName

## create share
$shareName = ""
New-AzRmStorageShare -ResourceGroupName $resourceGroup -StorageAccountName $wvdStorageAccount.StorageAccountName -Name $shareName

## enable AD DS Auth - https://docs.microsoft.com/en-us/azure/storage/files/storage-files-identity-ad-ds-enable
## run on AD Joined machine with user account with HIGH creds
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/Azure-Samples/azure-files-samples/releases/download/v0.2.1/AzFilesHybrid.zip" -OutFile "c:\users\$env:USERNAME\desktop\AzFilesHybrid.zip"
Expand-Archive -Path c:\users\$env:USERNAME\desktop\AzFilesHybrid.zip -DestinationPath c:\users\$env:USERNAME\desktop\AzFilesHybrid
cd c:\users\$env:USERNAME\desktop\AzFilesHybrid

## https://docs.microsoft.com/en-us/azure/storage/files/storage-files-identity-ad-ds-enable#run-join-azstorageaccountforauth
##run this code on the remote VM still
#Change the execution policy to unblock importing AzFilesHybrid.psm1 module
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
# Navigate to where AzFilesHybrid is unzipped and stored and run to copy the files into your path
.\CopyToPSPath.ps1 
#Import AzFilesHybrid module
Import-Module -Name AzFilesHybrid
#Login with an Azure AD credential that has either storage account owner or contributor Azure role assignment
Connect-AzAccount
#Select the target subscription for the current session
Select-AzSubscription -SubscriptionId $subid 
Join-AzStorageAccountForAuth -ResourceGroupName $ResourceGroup -StorageAccountName $wvdStorageAccountName -DomainAccountType ComputerAccount #-OrganizationalUnitDistinguishedName "<ou-distinguishedname-here>" # If you don't provide the OU name as an input parameter, the AD identity that represents the storage account is created under the root directory.
#You can run the Debug-AzStorageAccountAuth cmdlet to conduct a set of basic checks on your AD configuration with the logged on AD user. This cmdlet is supported on AzFilesHybrid v0.1.2+ version. For more details on the checks performed in this cmdlet, see Azure Files Windows troubleshooting guide.
Debug-AzStorageAccountAuth -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName -Verbose

# Get the target storage account
$wvdStorageAccountCheck = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $wvdStorageAccountName
# List the directory service of the selected service account
$wvdStorageAccountCheck.AzureFilesIdentityBasedAuth.DirectoryServiceOptions
# List the directory domain information if the storage account has enabled AD DS authentication for file shares
$wvdStorageAccountCheck.AzureFilesIdentityBasedAuth.ActiveDirectoryProperties