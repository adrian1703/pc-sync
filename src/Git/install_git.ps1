#! /usr/bin/env pwsh

# 1. Define the URL of the Git Bash installer
$git_exe='GitBashInstaller.exe'
$git_dl_link='https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/Git-2.47.1-64-bit.exe'
$downloadFolder = "c:/development/temp"
$config_file = "./git_options.ini"

# 2. Define the path where the installer will be saved
if (!(Test-Path $downloadFolder)) {
    New-Item -ItemType Directory -Force -Path $downloadFolder
}
$installerPath = "$downloadFolder/$git_exe"

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