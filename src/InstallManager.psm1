#! /usr/bin/env pwsh
function Invoke-Download
{
    param (
    # Mandatory
        [Parameter(Mandatory = $true, HelpMessage = "Enter the download link")]
        [Alias("dl")]
        [string] $link
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the download filename")]
        [Alias("fn")]
        [string] $fileName
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the download folder")]
        [Alias("df")]
        [string] $downloadFolder = "$env:TMP"
    )

    if ($fileName -eq $null)
    {
        $fileName = Split-Path -Path $link -Leaf
    }
    $fullPath = Join-Path $downloadFolder $fileName

    Write-Host "Download link: $link"
    Write-Host "Download folder: $downloadFolder"
    Write-Host "Full file path: $fullPath"


    # Ensure target folder exists
    if (!(Test-Path -Path $downloadFolder))
    {
        New-Item -ItemType Directory -Path $downloadFolder | Out-Null
    }
    # delete file if exists
    if (Test-Path -Path $fullPath)
    {
        Write-Host "Existing file found at $fullPath, removing it."
        Remove-Item -Path $fullPath -Force
    }
    # init
    $result = @{
        Status = "Error"
        Path = $fullPath
        Message = "Download failed; the file was not found at the specified path."
    }

    # Attempt to download the file
    try
    {
        Write-Host "Attempting to download the file..."
        Invoke-WebRequest -Uri $link -OutFile $fullPath
        $result = @{
            Status = "Success"
            Path = $fullPath
            Message = "Download complete."
        }
    }
    catch
    {
        Write-Host "Error during file download: $_"
        $result = @{
            Status = "Error"
            Path = $fullPath
            Message = "An error occurred during download: $_"
        }
    }
    # Output the final result as both a message and return value
    Write-Host $result
    return $result
}


function Invoke-InstallExe
{
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the download filename")]
        [Alias("fn")]
        [string] $fileName
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the file location")]
        [Alias("fl")]
        [string] $fileLocation = "$env:TMP"
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the installation args")]
        [Alias("ia")]
        [Array]$installArgs
    )
    $installerFullPath = Join-Path $fileLocation + $fileName
    Write-Host "Executing command: $installerFullPath $( $installArgs -join ' ' )"
    & $installerFullPath @installArgs
    Write-Host "Done invoking install command. May or may not be successful."
}

function Start-RunAllTasks {
    param (
        [Parameter(HelpMessage = "Enter the path to run config yaml")]
        [Alias("cfp")]
        [string] $configPath
    ,
        [Parameter(HelpMessage = "Enter the path to run config object")]
        [Alias("cfo")]
        [string] $configObject
    ,
        [Parameter(HelpMessage = "Test Flag; Set to not execute.")]
        [Alias("dry")]
        [switch] $dry
    )

    $configObject = Read-Config $configPath $configObject
    $schema       = $configObject.schema
    $tasks        = $configObject.tasks
    $cnt          = 1
    $total        = $tasks.Count
    foreach ($task in $tasks)
    {
        $taskName = task.name
        Write-Host "Running task $cnt from $total : `t$taskName"
        Start-RunTaskAllActions -cfo $configObject -tn $taskName -dry:$dry
        $cnt += 1
    }
}

function Start-RunTaskAllActions {
    param (
        [Parameter(HelpMessage = "Enter the path to run config yaml")]
        [Alias("cfp")]
        [string] $configPath
    ,
        [Parameter(HelpMessage = "Enter the path to run config object")]
        [Alias("cfo")]
        [string] $configObject
    ,
        [Parameter(HelpMessage = "Test Flag; Set to not execute.")]
        [Alias("dry")]
        [switch] $dry
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the execution task")]
        [Alias("tn")]
        [string]$taskName
    )

    $configObject  = Read-Config $configPath $configObject
    $task          = $null
    foreach ($item in $configObject.tasks)
    {
        if ($taskName -eq $item.name)
        {
            $task = $item
            break
        }
    }
    if ($task -eq $null) {
        throw "The provided taskName(=$taskName) is not present in configObject."
    }
    $actions = $task.actions
    $cnt     = 1
    $total   = $actions.Count
    foreach ($action in $actions)
    {
        $actionName = $action.cmd
        Write-Host "Running action $cnt from $total : `t${action.name}"
        Start-RunTaskAction -cfo $configObject -tn $taskName -an $actionName -dry:$dry
    }
}

function Start-RunTaskAction {
    param (
        [Parameter(HelpMessage = "Enter the path to run config yaml")]
        [Alias("cfp")]
        [string] $configPath
    ,
        [Parameter(HelpMessage = "Enter the path to run config object")]
        [Alias("cfo")]
        [string] $configObject
    ,
        [Parameter(HelpMessage = "Test Flag; Set to not execute.")]
        [Alias("dry")]
        [switch] $dry
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the execution task")]
        [Alias("tn")]
        [string]$taskName
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the action of task")]
        [Alias("an")]
        [string]$actionName
    )

    # Validating
    $configObject = Read-Config $configPath $configObject
    $taskObject = $configObject.$taskName
    if ($taskObject -eq $null) {
        throw "The provided taskName(=$taskName) is not present in configObject."
    }
    $actionObject = $taskObject.$actionName
    if ($taskObject -eq $null) {
        throw "The provided actionName(=$actionName) is not present in taskObject."
    }





}

function Read-Config {
    param (
        [Parameter(HelpMessage = "Enter the path to run config yaml")]
        [Alias("cfp")]
        [string] $configPath
    ,
        [Parameter(HelpMessage = "Enter the path to run config object")]
        [Alias("cfo")]
        [string] $configObject
    )
    if (-not $configObject -and -not $configPath) {
        throw "You must provide at least one of the following parameters: `-configPath` or `-configObject`."
    }

    if($configObject -eq $null) {
        $yamlContent = Get-Content -Raw -Path $configPath
        $yamlContent = Replace-EnvVarsPlaceholders -in $yamlContent
        return ConvertFrom-Yaml -Yaml $yamlContent
    }
    return $configObject
}

function Replace-EnvVarsPlaceholders {
    param (
        [Parameter(Mandatory = $true)]
        [alias("in")]
        [string]$inputString
    )
    $result = [regex]::replace($InputString, '\$\{(.*?)\}', {
        param($match)
        $envVarName = $match.Groups[1].Value
        return [System.Environment]::GetEnvironmentVariable($envVarName)
    })
    return $result
}


