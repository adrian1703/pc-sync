# 1. Define the URL of the Git Bash installer
$gitBashUrl = "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/PortableGit-2.47.1-64-bit.7z.exe"
$downloadFolder = "$env:DEV\temp"

# 2. Define the path where the installer will be saved
if (!(Test-Path $downloadFolder)) {
    New-Item -ItemType Directory -Force -Path $downloadFolder
}
$installerPath = "$downloadFolder\GitBashInstaller.exe"

# 3. Download the installer
Write-Host "Downloading Git Bash installer... to $installerPath"
Invoke-WebRequest -Uri $gitBashUrl -OutFile $installerPath

# 4. Install Git Bash
#Write-Host "Installing Git Bash..."
#Start-Process -FilePath $installerPath -Args "/VERYSILENT /NORESTART" -NoNewWindow -Wait
#
## 5. Clean up the installer
#Remove-Item -Path $installerPath
#Write-Host "Git Bash installed successfully!"