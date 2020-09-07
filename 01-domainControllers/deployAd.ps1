##Populate as needed for housing AD components
$location = ""
$resourceGroup = ""
$subid = ""

New-AzResourceGroup -Name $resourceGroup -Location $location #use this command when you need to create a new resource group for your deployment

##if you want to use a parmaeter file
#New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateUri https://raw.githubusercontent.com/fskelly/wvd-lab-test/master/domainControllers/templates/azuredeploy.json -TemplateParameterUri https://raw.githubusercontent.com/fskelly/wvd-lab-test/master/domainControllers/templates/parameters.json

cd .\01-domainControllers\templates\

##if you want to provide parameters - prompted
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile .\azuredeploy.json
#New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateUri https://raw.githubusercontent.com/fskelly/wvd-lab-test/master/domainControllers/templates/azuredeploy.json