#! /usr/bin/env pwsh
function Invoke-Download
{
    param (
    # Mandatory
        [Parameter(Mandatory = $true, HelpMessage = "Enter the tool name")]
        [Alias("t")]
        [string] $tool,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the download link")]
        [Alias("dl")]
        [string] $dlLink,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the name the downloaded file should be named")]
        [Alias("in")]
        [string] $installerName,

    # Optional
        [Parameter(Mandatory = $false, HelpMessage = "Enter the download folder")]
        [Alias("dlf")]
        [string] $dlFolder = "$env:TMP",
    # Test
        [Parameter(Mandatory = $false)]
        [switch] $skipDownload = $false # Default value is false
    )

    $installerFullPath=Join-Path $dlFolder $installerName

    echo "Downloading $tool ..."
    echo "download link: $dlLink"
    echo "installer: $installerName"
    echo "download folder: $dlFolder"
    echo "full: $installerFullPath"


    # Ensure target folder exists
    # mkdir -p "$dl_folder"
    if (!(Test-Path -Path $dlFolder))
    {
        New-Item -ItemType Directory -Path $dlFolder | Out-Null
    }

    # Download the installer
    if (!$skipDownload)
    {
        Invoke-WebRequest -Uri $dlLink -OutFile $installerFullPath
    }

    $result = $null
    # Check if download file exists
    if (Test-Path -Path $installerFullPath) {
        $result = @{
            Status  = "Success"
            Path    = $installerFullPath
            Message = "Download complete."
        }
    } else {
        $result = @{
            Status  = "Error"
            Message = "Download failed."
        }
    }
    echo $result
    return $result
}

function Invoke-Install {
    param (
        [Parameter(Mandatory=$true)]
        [Alias("p")]
        [string]$installerFullPath,

        [Parameter(Mandatory=$true)]
        [Alias("a")]
        [Array]$installArgs,

        [Parameter(Mandatory=$false)]
        [switch] $skipInstall = $false # Default value is false
    )
    echo "Executing command: $installerFullPath $($installArgs -join ' ')"
    if(!$skipInstall) {
        & $installerFullPath @installArgs
    }
    echo "Done installing. May or may not be successful lol"
}

function Invoke-CompleteInstall {
    param (

    )
}