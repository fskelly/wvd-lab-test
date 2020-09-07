prereqs - https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-install-prerequisites
installation - https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-install-select-installation
https://go.microsoft.com/fwlink/?LinkId=615771

```powershell
wget -O c:\users\$env:USERNAME\desktop\azureadconnect.msi https://download.microsoft.com/download/B/0/0/B00291D0-5A83-4DE7-86F5-980BC00DE05A/AzureADConnect.msi
cd c:\users\$env:USERNAME\desktop\
.\azureadconnect.msi
```
Finish the installation as per normal process, for this lab i used the express option - https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-install-express