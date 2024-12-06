#! /usr/bin/env pwsh
param (
# Define the configuration file parameter
    [Parameter(Mandatory=$false)]
    [string] $config_file = "./src/Git/git_options.ini", # Default value if no argument is supplied

# Define the skip download parameter
    [Parameter(Mandatory=$false)]
    [switch] $skipdownload = $false # Default value is false
)
# 1. Define the URL of the Git Bash installer
$git_exe='GitBashInstaller.exe'
$git_dl_link='https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/Git-2.47.1-64-bit.exe'
$downloadFolder = "c:/development/temp"

if (Test-Path $config_file) {
    # Print the first line of $config_file
    Write-Host "$config_file is present."
} else {
    Write-Host "$config_file does not exist."
    Exit
}

# 2. Define the path where the installer will be saved
if(!$skipdownload) {
    if (!(Test-Path $downloadFolder)) {
        New-Item -ItemType Directory -Force -Path $downloadFolder
    }
    $installerPath = "$downloadFolder/$git_exe"
} else {
    Write-Host "Skipping download of installer."
}

# 3. Download the installer
Write-Host "Downloading Git Bash installer... to $installerPath"
Invoke-WebRequest -Uri $git_dl_link -OutFile $installerPath

# 4. Install Git Bash
Write-Host "Installing Git Bash..."
Start-Process -FilePath $installerPath -Args "/VERYSILENT /NORESTART /NOCANCEL /LOADINF=$config_file"
#
## 5. Clean up the installer
#Remove-Item -Path $installerPath
#Write-Host "Git Bash installed successfully!"