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
        [string] $dl_link,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the name the downloaded file should be named")]
        [Alias("in")]
        [string] $installer,

    # Optional
        [Parameter(Mandatory = $false, HelpMessage = "Enter the download folder")]
        [Alias("dlf")]
        [string] $dl_folder = "$env:TMP",
    # Test
        [Parameter(Mandatory = $false)]
        [switch] $skipdownload = $false # Default value is false
    )

    $installer_full_path=Join-Path $dl_folder $installer

    echo "Downloading $tool ..."
    echo "download link: $dl_link"
    echo "installer: $installer"
    echo "download folder: $dl_folder"
    echo "full: $installer_full_path"


    # Ensure target folder exists
    # mkdir -p "$dl_folder"
    if (!(Test-Path -Path $dl_folder))
    {
        New-Item -ItemType Directory -Path $dl_folder | Out-Null
    }

    # Download the installer
    if (!$skipdownload)
    {
        Invoke-WebRequest -Uri $dl_link -OutFile $installer_full_path
    }

    $result = $null
    # Check if download file exists
    if (Test-Path -Path $installer_full_path) {
        $result = @{
            Status  = "Success"
            Path    = $installer_full_path
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