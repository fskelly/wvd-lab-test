$location = ""
$resourceGroup = ""
$subid = ""
Select-AzSubscription -Subscription $subid

##create new resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

##create new vnet and subnets
$wvdVnetName = ""
$wvdVnetAddressSpace = ""
New-AzVirtualNetwork -Name $wvdVnetName -ResourceGroupName $resourceGroup -Location $location -AddressPrefix $wvdVnetAddressSpace
$wvdVnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroup
$wvdSubnetName = ""
$wvdSubnetPrefix = ""
Add-AzVirtualNetworkSubnetConfig -Name $wvdSubnetName -VirtualNetwork $wvdVnet -AddressPrefix $wvdSubnetPrefix
$wvdVnet | Set-AzVirtualNetwork

#Create Peering between AD DS and WVD
$addsVnetName = ""
$addsVnetRG = ""
$addsVnet = Get-AzVirtualNetwork -Name $addsVnetName -ResourceGroupName $addsVnetRG
$vwdVnetName = ""
$wvdVnetRG = ""
$wvdVnet = Get-AzVirtualNetwork -Name $vwdVnetName -ResourceGroupName $wvdVnetRG 
$peer1Name = $addsVnetName + "-to-" + $vwdVnetName
$peer2Name = $vwdVnetName + "-to-" + $addsVnetName
Add-AzVirtualNetworkPeering -Name $peer1Name -VirtualNetwork $addsVnet -RemoteVirtualNetworkId $wvdVnet.Id
Add-AzVirtualNetworkPeering -Name $peer2Name -VirtualNetwork $wvdVnet -RemoteVirtualNetworkId $addsVnet.Id

##update Azure DNS to custom for WVD Vnet
$adVMRG = ""
$adVMName = ""
$vm = get-azvm -ResourceGroupName $adVMRG -Name $adVMName
$adNic = Get-AzNetworkInterface -Name ($vm.NetworkProfile.NetworkInterfaces.Id).split("/")[8] -ResourceGroupName ($vm.NetworkProfile.NetworkInterfaces.Id).split("/")[4]
$advmIp = $adNic.IpConfigurations.privateIpaddress

$DNSIPs = @()
$DNSIPs += $advmIp
$DNSIPs += "8.8.8.8"
foreach ($IP in $DNSIPs)
{
    $wvdVnet.DhcpOptions.DnsServers += $IP
}
Set-AzVirtualNetwork -VirtualNetwork $wvdVnet