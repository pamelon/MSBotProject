# Azure DevOps release pipeline has defined variables that are used through out the scripts

# Include common functions
. "$PSScriptRoot\common_functions.ps1"

$settingsFilePath = ".\appsettings.$($environment).json"
$settings = Get-Content -Raw -Path $settingsFilePath | ConvertFrom-Json

SetVariable "ResourceGroupName" $settings.ResourceGroupName
SetVariable "ApplicationName" $settings.ApplicationName
SetVariable "StorageName" $("$($settings.ApplicationName)$($environment)stg" -replace "-", "")
SetVariable "LuisRuntimeSKU" $settings.LuisRuntimeSKU

Write-Host "$($MyInvocation.MyCommand.Name) finished reading $settingsFilePath"