#Requires -Version 5.1
#Requires -Module Az.Resources
#Requires -Module Az.Storage
#Requires -Module Az.ApplicationInsights

[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true)]
    [String]$storageAccountName
)
# This script configures the storage account.

# If the file is 0 bytes, we will upload it if not exists but will not replace it if it already exists

# We will create the containers found in the storage_containers folder

$storageContainersToCreate = Get-ChildItem $PSScriptRoot\storage_containers -Directory | ForEach-Object { $_.Name }

# Read Permissions file, convert it into hashtable and setup 'Off' for thoses that are not explicitely defined in that file
$permissionsJson = Get-Content -Raw -Path $PSScriptRoot\storage_containers\permissions.json | ConvertFrom-Json
$permissions = @{}
$permissionsJson.psobject.properties | Foreach { $permissions[$_.Name] = $_.Value }
foreach ($storageContainer in $storageContainersToCreate) 
{
 if ($permissions.ContainsKey($storageContainer) -ne $true){
   $permissions[$storageContainer] = 'Off'
 }
}

$paramGetAzResource = @{
		ResourceType = "Microsoft.Storage/storageAccounts"
		Name = $storageAccountName
}
$storageResource = Get-AzResource @paramGetAzResource

Write-Host "Getting storage account key for storage account $storageAccountName"
$paramInvokeAzResourceAction = @{
		Action	   = 'listkeys'
		ResourceId = $storageResource.ResourceId
		Force	   = $true
}
$storageAccountKey = (Invoke-AzResourceAction @paramInvokeAzResourceAction).keys[0].value

Write-Host "Getting storage context"
$paramNewAzStorageContext = @{
		StorageAccountName = $storageAccountName
		StorageAccountKey  = $storageAccountKey
}
$storageContext = New-AzStorageContext @paramNewAzStorageContext

function UploadFile($storageContext, $storageContainer,$absoluteBlobUri,$fullPath, $replaceFlag){
	try
	{   
		$blob = Get-AzStorageBlob -Blob $absoluteBlobUri -Container $storageContainer -Context $storageContext -ErrorAction Stop
        if ($replaceFlag){
            Write-Host "'$storageContainer' > Replacing file '$absoluteBlobUri'"    
            Set-AzStorageBlobContent -File $fullPath -Container $storageContainer -Blob $absoluteBlobUri -Context $storageContext -Force
        }else{
            Write-Host "'$storageContainer' > File '$absoluteBlobUri' already exists" 
        }
	}
	catch [Microsoft.WindowsAzure.Commands.Storage.Common.ResourceNotFoundException]
	{
		Write-Host "'$storageContainer' > Uploading file '$absoluteBlobUri'"
        Set-AzStorageBlobContent -File $fullPath -Container $storageContainer -Blob $absoluteBlobUri -Context $storageContext -Force
		return
	}
	catch
	{
		# Report any other error
		throw $Error;
	}
}

# Iterating through the list of the storage containers that need to be created.
foreach ($storageContainer in $storageContainersToCreate) 
{
    $getContainer = Get-AzStorageContainer -Context $storageContext -Name $storageContainer -ErrorAction:Ignore
    If($getContainer -eq $null) {
	    Write-Host "Creating '$storageContainer' container"
        $paramNewAzStorageContainer = @{
	    	Name	   = $storageContainer
	    	Context    = $storageContext
	    	Permission = $permissions[$storageContainer]
	    }
	    New-AzStorageContainer @paramNewAzStorageContainer -ErrorAction:Stop
    } Else {
        Write-Host "'$storageContainer' container exists"
    }
    # We will also upload all files in the git included storage container, besides the placeholder.txt
    foreach($file in (Get-ChildItem $PSScriptRoot\storage_containers\$storageContainer -Recurse -File| Where {$_.Name.ToLower() -ne "placeholder.txt"})){
        $absoluteBlobUri = ($file.FullName -ireplace [regex]::Escape("$PSScriptRoot\storage_containers\$storageContainer\"), "") -replace [regex]::Escape("\"), "/"
        # If the local file is 0 length this means that is acts as a placeholder that will be replaced by 
        # some other pipeline (like the zip files of the ADF pipeline)
        $replaceFlag = ($file.Length -ne 0)
        $fullPath = $file.FullName
        UploadFile $storageContext $storageContainer $absoluteBlobUri $fullPath $replaceFlag
    }
}

Write-Host "$($MyInvocation.MyCommand.Name) finished"