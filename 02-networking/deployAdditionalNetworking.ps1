$location = ""
$resourceGroup = ""
$subid = ""

#from previous script
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroup
$mgmtSubnetName = "mgmt-subnet"
$mgmtSubnetPrefix = "10.1.0.32/27"
Add-AzVirtualNetworkSubnetConfig -Name $mgmtSubnetName -VirtualNetwork $vnet -AddressPrefix $mgmtSubnetPrefix
$vnet | Set-AzVirtualNetwork

$bastionSubnnetName = "AzureBastionSubnet"
$bastionPIP = $vnet.Name + "-bastion-pip-1"
$bastionName = $vnet.Name + "-bastion-1"
$bastionSubnetPrefix = "10.1.0.64/27"
Add-AzVirtualNetworkSubnetConfig -Name $bastionSubnnetName -VirtualNetwork $vnet -AddressPrefix $bastionSubnetPrefix
$vnet | Set-AzVirtualNetwork
$bastionPublicip = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -name $bastionPIP -location $vnet.Location -AllocationMethod Static -Sku Standard
$bastion = New-AzBastion -ResourceGroupName $resourceGroup -Name $bastionName -PublicIpAddress $bastionPublicip -VirtualNetwork $vnet

##optional
$gatewaySubnetName = "GatewaySubnet"
$gatewaySubnetPrefix = "10.1.0.128/27"
Add-AzVirtualNetworkSubnetConfig -Name $gatewaySubnetName -VirtualNetwork $vnet -AddressPrefix $gatewaySubnetPrefix
$vnet | Set-AzVirtualNetwork
