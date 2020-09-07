##Populate as needed for housing WVD components (WVD needs a blank RG)
$location = "westus2"
$resourceGroup = "flkelly-westus2-wvdlab2"
$subid = "949ef534-07f5-4138-8b79-aae16a71310c"
New-AzResourceGroup -Name $resourceGroup -Location $location

##Populate as needed for housing WVD vnet (WVD needs a blank RG)
$location = "westus2"
$resourceGroup = "flkelly-westus2-wvdlab3"
$subid = "949ef534-07f5-4138-8b79-aae16a71310c"
New-AzResourceGroup -Name $resourceGroup -Location $location
$vnetName = "vwd-vnet"
$vnetPrefix = "172.16.0.0/16"
$subnetName = "vwd-snet"
$subnetPrefix = "172.16.1.0/24"
$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location -Name $vnetName -AddressPrefix $vnetPrefix
$subnetConfig = Add-AzVirtualNetworkSubnetConfig  -Name $subnetName -AddressPrefix $subnetPrefix -VirtualNetwork $virtualNetwork
$virtualNetwork | Set-AzVirtualNetwork

##AD VNET variables - need the peering in place
$adVnetName = "adVNET"
$adVNnetResourceGroup = "flkelly-westus2-wvdlab1"
$adVnet = Get-AzVirtualNetwork -Name $adVnetName -ResourceGroupName $adVNnetResourceGroup
$peering1Name = $adVnet.name + "-to-" + $virtualNetwork.Name
Add-AzVirtualNetworkPeering -Name $peering1Name -VirtualNetwork $adVnet -RemoteVirtualNetworkId $virtualNetwork.Id
$peering2Name = $virtualNetwork.Name + "-to-" + $adVnet.name
Add-AzVirtualNetworkPeering -Name $peering2Name -VirtualNetwork $virtualNetwork -RemoteVirtualNetworkId $adVnet.Id