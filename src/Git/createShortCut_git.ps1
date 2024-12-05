$dev = "C:\Development"
$git = "PortableGit"
$scripts = "SetupScripts"


## Path to Git Bash executable
$workdir = "$env:DEV\$git"
$gitBashPath = "$workdir\git-bash.exe"  # Adjust if needed


# Specify the .exe path and the shortcut name
$PathToYourExe = "$gitBashPath"
$ShortcutName = "Bash"

# Get the Startup folder path
$StartMenuPath = [Environment]::GetFolderPath('Programs')

# Create the full path for the shortcut
$ShortcutPath = Join-Path -Path $StartMenuPath -ChildPath "$ShortcutName.lnk"

# Create a WScript Shell to create a shortcut object
$WScriptShell = New-Object -comobject WScript.Shell

# Create a shortcut object for the .exe path
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $PathToYourExe

# Save the shortcut
$Shortcut.Save()

Write-Host "Shortcut created"