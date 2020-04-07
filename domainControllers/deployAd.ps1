##Populate as needed
$location = ""
$resourceGroup = ""
$subid = ""


New-AzResourceGroup -Name $resourceGroup -Location $location #use this command when you need to create a new resource group for your deployment
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateUri https://raw.githubusercontent.com/fskelly/wvd-lab-test/master/domainControllers/templates/azuredeploy.json -TemplateParameterUri https://raw.githubusercontent.com/fskelly/wvd-lab-test/master/domainControllers/templates/parameters.json
