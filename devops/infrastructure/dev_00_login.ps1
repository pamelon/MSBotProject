param(
  [Parameter(Mandatory=$true)]
  [string]$environment = ""
)

# Include common functions
. "$PSScriptRoot\common_functions.ps1"

# Keep environment variable to use in rest of the scripts
SetVariable "environment" "$environment"

# All settings are set in the following script
$environmentSettingsFilePath = ".\appsettings.$($environment).json"

# Logins to the target Azure subscription in the specified tenant
if (Test-Path $environmentSettingsFilePath) {

    $settings = Get-Content -Raw -Path $environmentSettingsFilePath | ConvertFrom-Json
    # The local.settings.json contains the following object
    # {
    #   "TenantId": "",
    #   "SubscriptionId": ""
    # }

    # If for example you are connecting to the exampleTenant.onmicrosoft.com tenant,
    # the tenant id, aka Directory ID, can be found from 
    # https://portal.azure.com/#@exampleTenant.onmicrosoft.com/blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Properties
    $tenantId = $settings.TenantId

    # The subscription id can be found from 
    # https://ms.portal.azure.com/#@exampleTenant.onmicrosoft.com/blade/Microsoft_Azure_Billing/SubscriptionsBlade
    $subscriptionId = $settings.SubscriptionId

    # Login to specific subscription in the specific tenant
    Connect-AzAccount -Subscription $subscriptionId  -Tenant $tenantId
}
else {
    Write-Host "$environmentSettingsFilePath file not found. This file should have at least the following entries:"
    Write-Host "   {"
    Write-Host '     "TenantId": "",'
    Write-Host '     "subscriptionId": ""'
    Write-Host "   }"
    Write-Host "Where TenantId can be discovered going to "
    Write-Host "https://portal.azure.com/#@TENANTNAME.onmicrosoft.com/blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Properties"
    Write-Host "and SubscriptionId from "
    Write-Host "https://ms.portal.azure.com/#@TENANTNAME.onmicrosoft.com/blade/Microsoft_Azure_Billing/SubscriptionsBlade"
}

Write-Host "`n$($MyInvocation.MyCommand.Name) finished"