#! /usr/bin/env pwsh

###################### Params          ######################
param (
    [Parameter(Mandatory=$false)]
    [switch] $skipdownload = $false, # Default value is false

    [Parameter(Mandatory=$false)]
    [switch] $skipinstall = $false # Default value is false
)

###################### Imports          ######################
Import-Module ./src/Utils.psm1

###################### Config Variables ######################
$tool      = "Rider"
$dl_link   = "https://download.jetbrains.com/rider/JetBrains.Rider-2024.3.4.exe"
$installer = "rider_install.exe"

$trgt_folder   =Join-Path $env:IDES       "jetbrains\Rider" # this is somehow sometimes lowercase dont ask me why
$silent_config =Join-Path $env:SETUP_PROJ "src\rider\silent.config"
$log_file      =Join-Path $env:TMP        "rider_install.log"

$installer_full_path = $null

$cmd_args = @(
    "/S",
    "/CONFIG=$silent_config",
    "/LOG=$log_file",
    "/D=$trgt_folder"
)

###################### Downloading      ######################
$dl_result = Invoke-Download   `
                -t  $tool      `
                -dl $dl_link   `
                -in $installer `
                -skipdownload $skipdownload
        
$installer_full_path=$dl_result.Path

###################### Executing        ######################
Invoke-Install `
    -p $installer_full_path `
    -a $cmd_args `
    -skipinstall $skipinstall
