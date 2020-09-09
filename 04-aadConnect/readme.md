# How to Use

## Pre-reqs  

[Prereqs for instalaltion](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-install-prerequisites)  
[How to install](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-install-select-installation)  
[Microsoft Azure Active Directory Connect Download](https://go.microsoft.com/fwlink/?LinkId=615771)

## Installation  

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://download.microsoft.com/download/B/0/0/B00291D0-5A83-4DE7-86F5-980BC00DE05A/AzureADConnect.msi" -OutFile "c:\users\$env:USERNAME\desktop\azureadconnect.msi"
cd c:\users\$env:USERNAME\desktop\
.\azureadconnect.msi
```

Finish the installation as per normal process, for this lab I used the [express option](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-install-express)