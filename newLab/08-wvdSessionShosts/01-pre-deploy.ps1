write-host "You will need to update the parameters.json file"

$rgName = "flkelly-wus-wvd-arm"
$hostPoolName = "fktest-1"
$dag = $hostPoolName + "-DAG"

$hostpool = Get-AzWvdHostPool | Where-Object {$_.name -eq $hostPoolName}
$hostpoolFriendlyName = $hostPool.FriendlyName
$hostpoolDescription = $hostpool.Description
$hostpoolPoolType = $hostpool.HostPoolType
$hostpoolToken = $token.Token
$appReference = $hostpool.ApplicationGroupReference

$expirationTime = (Get-Date).ToUniversalTime().AddDays(2).ToString('yyyy-MM-ddTHH:mm:ss.fffffffZ')

write-host "hostpoolName : $hostPoolName"
write-host "hostpoolToken : $hostpoolToken"
Write-Host "hostpoolResourceGroup : $hostPoolName"
Write-host "friendlyName : $hostpoolFriendlyName"
Write-Host "description : $hostpoolDescription"
Write-Host "hostPoolType : $hostpoolPoolType"
Write-Host "applicationGroupReferences : $appReference"
write-host "registrationinfo-expirationTime : $expirationTime"
write-host "registrationinfo-hostpoolToken : $hostpoolToken"



Write-Host "vmTemplate - please remember to update your domain - using example.com"
Write-Host "vmResourceGroup : $rgName"
write-host "update vmNamePrefix"
write-host "update existingVnetName"
write-host "update existingSubnetName"
write-host "update virtualNetworkResourceGroupName"