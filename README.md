# Targets

## How to use
### Git Bash installieren
1. open powershell 
2. nav to the root of this proj
3. check the variables for install_git.ps1 ... version, target-path .. they need to match with ```environments.ini```
4. ```./src/Git/install_git.ps1```
     1. ``-skipdownload`` for skipping the download
     2. ``-config_file "adsf/asdf.asdf"`` for configuring custom git_options (not recommended)
### Setting up shell and sys environment
1. open bash
2. nav to the root of this proj
3. ``./environment_set_as_sys_vars.sh`` for setting the env vars
4. check if ides is capitalized
5. reopen bash (for loading sys vars into the bash context)
6. nav to the root of this proj
7. ``./git_config.sh -pull`` for pulling git config
---

### Installing common software using powershell
Either call these directly in powershell or execute powershell in
bash and then use the embedded powershell to execute.

e.g.
```terminal
remote@MyServer MINGW64 ~
$ proj

remote@MyServer MINGW64 /c/development/projects
$ powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. Alle Rechte vorbehalten.

Lernen Sie das neue plattformübergreifende PowerShell kennen – https://aka.ms/ps
core6

PS C:\development\projects> cd .\ReinstallPc\
PS C:\development\projects\ReinstallPc> .\src\rider\install.ps1
Installing Rider ...
download link: https://download.jetbrains.com/rider/JetBrains.Rider-2024.3.4.exe
installer: ideaIU-latest.exe
download folder: C:\DEVELO~1\temp
full: C:\DEVELO~1\temp\ideaIU-latest.exe
target folder: C:\development\ides\jetbrains\Rider
Download complete
Running the installer in silent mode...
Failed to install Rider.
PS C:\development\projects\ReinstallPc> 
```   

- ```src/intellij/install.ps1```
- ```src/rider/install.ps1```
- ```src/jetbrains-toolbox/install.ps1```
   - kinda meh about this.. installs in appdata
   - need to configure path to $ides
- ```src/chrome/install.ps1```
---
## Shell helper

There are some helper scripts in the root of the project:

- ``environment_load_as_vars.sh``
- ``environment_set_as_sys_vars.sh``

## Sync Git Config

The ```git_config``` command can sync the ```Git/etc``` folder using the following options:

- ``git_config -push``
- ``git_config -pull``