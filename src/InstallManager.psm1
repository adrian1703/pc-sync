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

function Start-RunAllTargets {
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

    $yamlContent   = Get-Content -Raw -Path $configPath
    $configObject  = ConvertFrom-Yaml -Yaml $yamlContent
    $targets = $targetObject.actions
    foreach ($action in $actions)
    {
        Start-TargetAction -cfo $configObject -tn $targetName -dry:$dry
    }
}

function Start-RunTargetAllActions {
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
        [Parameter(Mandatory = $true, HelpMessage = "Enter the execution target")]
        [Alias("tn")]
        [string]$targetName
    )

    $yamlContent   = Get-Content -Raw -Path $configPath
    $configObject  = ConvertFrom-Yaml -Yaml $yamlContent
    if ($targetObject -eq $null) {
        throw "The provided targetName(=$targetName) is not present in configObject."
    }
    $actions = $targetObject.actions
    foreach ($action in $actions)
    {
        $actionName = $action.Keys
        Start-TargetAction -cfo $configObject -tn $targetName -dry:$dry
    }
}

function Start-RunTargetAction {
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
        [Parameter(Mandatory = $true, HelpMessage = "Enter the execution target")]
        [Alias("tn")]
        [string]$targetName
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the action of target")]
        [Alias("an")]
        [string]$actionName
    )

    # Validating
    $configObject = Read-Config $configPath $configObject
    $targetObject = $configObject.$targetName
    if ($targetObject -eq $null) {
        throw "The provided targetName(=$targetName) is not present in configObject."
    }
    $actionObject = $targetObject.$actionName
    if ($targetObject -eq $null) {
        throw "The provided actionName(=$actionName) is not present in targetObject."
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
        return ConvertFrom-Yaml -Yaml $yamlContent
    }
    return $configObject
}

