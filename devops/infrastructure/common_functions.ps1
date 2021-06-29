function VSTOSetupVariable([string] $variableName, [string] $variableValue){
    # Set the variable for the local development environment
    SetVariable $variableName $variableValue
    # Set the variable for VSTO
    Write-Host ("##vso[task.setvariable variable=$variableName;]$variableValue")
    Write-Output ("##vso[task.setvariable variable=$variableName;]$variableValue")
}

function SetVariable([string] $variableName,[string] $variableValue){
    Set-Variable -Name $variableName -Value $variableValue -Scope 1
    Set-Variable -Name $variableName -Value $variableValue -Scope Script
    Set-Variable -Name $variableName -Value $variableValue -Scope Global
}

function ExecuteStep([string] $filename, [string] $params){
$scriptCommand = "$filename $params"
# Original source code from 
# https://github.com/Microsoft/vsts-tasks/blob/master/Tasks/AzurePowerShell/AzurePowerShell.ps1
([scriptblock]::Create($scriptCommand)) |
        ForEach-Object {
            Write-Host "##[command]$_"
            . $_ 2>&1
        } |
        ForEach-Object {
            # Put the object back into the pipeline. When doing this, the object needs
            # to be wrapped in an array to prevent unraveling.
            ,$_
            # Set the task result to failed if the object is an error record.
            if ($_ -is [System.Management.Automation.ErrorRecord]) {
                "##vso[task.complete result=Failed]"
            }
        }
}


function Safe-Http-Delete($url, $headers){
    try{
        Invoke-RestMethod -Method DELETE -Uri $url -Headers $headers -ErrorAction Continue
	}catch{
        Write-Host "Delete http request to $url failed but was expected"
	}
}