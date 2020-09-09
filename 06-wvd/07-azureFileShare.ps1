##Map file user to U:
$connectTestResult = Test-NetConnection -ComputerName wvdweuprofiles.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Mount the drive
    New-PSDrive -Name U -PSProvider FileSystem -Root "\\<StorageAccountname>.file.core.windows.net\<fileshare>" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

$connectTestResult = Test-NetConnection -ComputerName <StorageAccountname>.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded)
{
  net use u: \\<StorageAccountname>.file.core.windows.net\<fileshare> /user:Azure\flkellyfslogix01 <StorageAccountKey>
} 
else 
{
  Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN,   Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}