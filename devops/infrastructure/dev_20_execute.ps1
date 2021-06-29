# To debug an ARM template append the following flags: 
# -DeploymentDebugLogLevel All -Debug -Verbose

# You can comment out steps you want to avoid 
$executeSteps = @(
"step010",
"step020",
#"step030",
#"step031", # Example of intermediate step added later in the process
#"step040",
#"step050",
#"step060",
#"step070",
#"step080",
#"step090",
#"step100",
#"step110",
#"step120"
 "left on purpose to avoid removing commas while commenting out")


# Include common functions
. "$PSScriptRoot\common_functions.ps1"


if ($executeSteps -contains "step010"){
    New-AzResourceGroupDeployment -Mode Incremental `
          -TemplateFile "step_010_Storage.deploy.json" `
          -ResourceGroupName $ResourceGroupName `
          -resourceName $StorageName

	ExecuteStep("$PSScriptRoot\step_011_Storage_Upload_Containers","-storageAccountName $StorageName")
}

if ($executeSteps -contains "step020"){
    New-AzResourceGroupDeployment -Mode Incremental `
          -TemplateFile "step_020_luis_app.deploy.json" `
          -ResourceGroupName $ResourceGroupName `
          -resourceName $ApplicationName `
          -environment $environment `
          -runtimeSku $LuisRuntimeSKU
}

Write-Host "$($MyInvocation.MyCommand.Name) finished for environment $environment"