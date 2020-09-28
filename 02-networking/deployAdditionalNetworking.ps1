$location = ""
$resourceGroup = ""
$subid = ""
Select-AzSubscription -Subscription $subid

#from previous script
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroup
$mgmtSubnetName = ""
$mgmtSubnetPrefix = ""
Add-AzVirtualNetworkSubnetConfig -Name $mgmtSubnetName -VirtualNetwork $vnet -AddressPrefix $mgmtSubnetPrefix
$vnet | Set-AzVirtualNetwork

$bastionSubnnetName = "AzureBastionSubnet"
$bastionPIP = $vnet.Name + ""
$bastionName = $vnet.Name + ""
$bastionSubnetPrefix = ""
Add-AzVirtualNetworkSubnetConfig -Name $bastionSubnnetName -VirtualNetwork $vnet -AddressPrefix $bastionSubnetPrefix
$vnet | Set-AzVirtualNetwork
$bastionPublicip = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -name $bastionPIP -location $vnet.Location -AllocationMethod Static -Sku Standard
$bastion = New-AzBastion -ResourceGroupName $resourceGroup -Name $bastionName -PublicIpAddress $bastionPublicip -VirtualNetwork $vnet

##optional
$gatewaySubnetName = "GatewaySubnet"
$gatewaySubnetPrefix = ""
Add-AzVirtualNetworkSubnetConfig -Name $gatewaySubnetName -VirtualNetwork $vnet -AddressPrefix $gatewaySubnetPrefix
$vnet | Set-AzVirtualNetwork
