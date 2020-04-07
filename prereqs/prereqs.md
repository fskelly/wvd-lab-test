You need to install azbb first
https://github.com/mspnp/template-building-blocks/wiki/Install-Azure-Building-Blocks

Cloudshell
```bash
LOCATION="westus2"
RGGROUP="flkelly-westus2-WVD"
SUB_ID="949ef534-07f5-4138-8b79-aae16a71310c"
azbb -g ${RGGROUP} -s ${SUB_ID} -l ${LOCATION} -p deploy.json --deploy
```

```powershell
$location = "westus2"
$resourceGroup = "flkelly-westus2-wvd"
$subid = "949ef534-07f5-4138-8b79-aae16a71310c"
azbb -g $resourceGroup -s $subid  -l $location -p adDeploy.json --deploy
```