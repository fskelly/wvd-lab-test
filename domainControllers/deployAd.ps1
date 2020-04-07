$location = "westus2"
$resourceGroup = "flkelly-westus2-wvd"
$subid = "949ef534-07f5-4138-8b79-aae16a71310c"


New-AzResourceGroup -Name $resourceGroup -Location $location #use this command when you need to create a new resource group for your deployment
#New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup  -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/active-directory-new-domain/azuredeploy.json

New-AzResourceGroupDeployment -TemplateParameterFile parameters.json -TemplateFile template.json