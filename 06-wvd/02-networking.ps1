$location = "westeurope"
$resourceGroup = "flkelly-weu-lab-wvd"
$subid = "949ef534-07f5-4138-8b79-aae16a71310c"

##create new resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

##create new vnet and subnets
$wvdVnetName = "flkelly-weu-wvd-vnet"
$wvdVnetAddressSpace = "10.1.2.0/24"
New-AzVirtualNetwork -Name $wvdVnetName -ResourceGroupName $resourceGroup -Location $location -AddressPrefix $wvdVnetAddressSpace
$wvdVnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroup
$wvdSubnetName = "wvd-subnet"
$wvdSubnetPrefix = "10.1.2.0/26"
Add-AzVirtualNetworkSubnetConfig -Name $wvdSubnetName -VirtualNetwork $wvdVnet -AddressPrefix $wvdSubnetPrefix
$wvdVnet | Set-AzVirtualNetwork

#Create Peering between AD DS and WVD
$addsVnetName = "flkelly-weu-lab-sharedservices-vnet"
$addsVnet = Get-AzVirtualNetwork -Name $addsVnetName
$vwdVnetName = "flkelly-weu-wvd-vnet"
$wvdVnet = Get-AzVirtualNetwork -Name $vwdVnetName
$peer1Name = $addsVnetName + "-to-" + $vwdVnetName
$peer2Name = $vwdVnetName + "-to-" + $addsVnetName
Add-AzVirtualNetworkPeering -Name $peer1Name -VirtualNetwork $addsVnet -RemoteVirtualNetworkId $wvdVnet.Id
Add-AzVirtualNetworkPeering -Name $peer2Name -VirtualNetwork $wvdVnet -RemoteVirtualNetworkId $addsVnet.Id

##update Azure DNS to custom for WVD Vnet
