<# $metaDataLocation = "westus"
$resourceGroup = "flkelly-weu-lab-wvd"
$subid = "949ef534-07f5-4138-8b79-aae16a71310c"
$hostPoolname = "flkelly-weu-lab-wvdpool1"
$workspaceName = "flkelly-weu-lab-wvdws1"
$appGroupName = "flkelly-weu-lab-wvdag1"
$poolType = "Pooled" #pooled / personal
$lbType = "DepthFirst"  #BreadthFirst/DepthFirst/Persistent
$wvdDescription = "Initial Deployment of WVD"
$maxSessionLimit = "5"
 
New-AzWvdHostPool -ResourceGroupName $resourceGroup -Name $hostPoolname -WorkspaceName $workspaceName -HostPoolType $poolType -LoadBalancerType $lbType -Location $metaDataLocation -DesktopAppGroupName $appGroupName #>

Working on automated deployment, still doing this manually
