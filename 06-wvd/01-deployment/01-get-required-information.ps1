##install MSOnline Module
Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "Insufficient permissions to run this script. Open the PowerShell console as an administrator and run this script again."
Break
}
else {
Write-Host "Code is running as administrator — go on executing the script..." -ForegroundColor Green
}

$tenantName = "flkellyinternal.onmicrosoft.com"
$URI = "https://login.windows.net/$tenantName/.well-known/openid-configuration"
$Response = Invoke-WebRequest -UseBasicParsing -Uri $URI -Method Get
$json = ConvertFrom-Json -InputObject $Response.Content
$json
$directoryId = ($json.token_endpoint).Split('/')[3]
Write-Host "Your Directory ID is " -nonewline
write-host -ForegroundColor Green $directoryId