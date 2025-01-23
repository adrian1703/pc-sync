#! /usr/bin/env pwsh

param (
# Define the skip download parameter
    [Parameter(Mandatory=$false)]
    [switch] $skipdownload = $false # Default value is false
)

$dl_link="https://download.jetbrains.com/idea/ideaIU-2024.3.1.1.exe"
$installer="ideaIU-latest.exe"
$dl_folder="$env:TMP"
$installer_full_path=Join-Path $dl_folder $installer
$trgt_folder=Join-Path $env:IDES "jetbrains\IntelliJ IDEA Ultimate" # this is somehow sometimes lowercase dont ask me why
$silent_config=Join-Path $env:SETUP_PROJ "src\intellij\silent.config"
$log_file=Join-Path $env:TMP "intellij_install.log"

echo "Installing Intellij ..."
echo "download link: $dl_link"
echo "installer: $installer"
echo "download folder: $dl_folder"
echo "full: $installer_full_path"
echo "target folder: $trgt_folder"

# Ensure target folder exists
# mkdir -p "$dl_folder"
if (!(Test-Path -Path $dl_folder))
{
    New-Item -ItemType Directory -Path $dl_folder | Out-Null
}

# Download the installer
if (!$skipdownload)
{
#    curl -L $dl_link -o $installer_full_path
    Invoke-WebRequest -Uri $dl_link -OutFile $installer_full_path
}

# Check if download file exists
if (Test-Path -Path $installer_full_path)
{
    echo "Download complete"
}
else
{
    echo "Download failed"
    exit 1
}

# Run installer silent mode
Write-Host "Running the installer in silent mode..."
& $installer_full_path "/S" "/CONFIG=$silent_config" "/LOG=$log_file" "/D=$trgt_folder"
Write-Host "Done installing. May or may not be successful lol"
# Idk if that works properly down there
# # Check installer success
# if ($LASTEXITCODE -eq 0)
# {
#     Write-Host "IntelliJ IDEA Ultimate installed successfully."
#     Write-Host "Log file: $log_file"
# }
# else
# {
#     Write-Host "Failed to install IntelliJ IDEA Ultimate."
#     exit 1
# }