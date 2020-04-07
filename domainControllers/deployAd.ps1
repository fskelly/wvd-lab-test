$location = "westus2"
$resourceGroup = "flkelly-westus2-wvd"
$subid = "949ef534-07f5-4138-8b79-aae16a71310c"


New-AzResourceGroup -Name $resourceGroup -Location $location #use this command when you need to create a new resource group for your deployment
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateUri https://raw.githubusercontent.com/fskelly/wvd-lab-test/master/domainControllers/templates/azuredeploy.json?token=ABPO4U6I2AGFDL4NCS43U4K6RSM32 -TemplateParameterUri https://raw.githubusercontent.com/fskelly/wvd-lab-test/master/domainControllers/templates/parameters.json?token=ABPO4U2XDXLRVKGWMC66LBS6RSNE6

#New-AzResourceGroupDeployment -TemplateParameterFile parameters.json -TemplateFile template.json
