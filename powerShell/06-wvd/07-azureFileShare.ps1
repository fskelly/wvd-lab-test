##Map file user to U:
$storageAccountName = ""
$storageAccountName = $storageAccountName + ".file.core.windows.net"
$connectTestResult = Test-NetConnection -ComputerName $storageAccountName -Port 445
$fileshareName = ""
$fileSharePath = $storageAccountName + "\" + $fileshareName
if ($connectTestResult.TcpTestSucceeded) {
    # Mount the drive
    New-PSDrive -Name U -PSProvider FileSystem -Root $fileSharePath -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

##OR##
$storageAccountName = ""
$storageAccountName = $storageAccountName + ".file.core.windows.net"
$connectTestResult = Test-NetConnection -ComputerName $storageAccountName -Port 445
$fileshareName = ""
$fileSharePath = "\\" + $storageAccountName + "\" + $fileshareName
$storageAccountKey = ""
if ($connectTestResult.TcpTestSucceeded)
{
  net use u: $fileSharePath /user:Azure\$storageAccountName $storageAccountKey
} 
else 
{
  Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN,   Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}