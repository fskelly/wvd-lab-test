[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://aka.ms/fslogix_download" -OutFile "c:\users\$env:USERNAME\desktop\fslogix.zip"
Expand-Archive -Path c:\users\$env:USERNAME\desktop\fslogix.zip -DestinationPath c:\users\$env:USERNAME\desktop\fslogix
cd c:\users\$env:USERNAME\desktop\fslogix\x64\Release
.\FSLogixAppsSetup.exe