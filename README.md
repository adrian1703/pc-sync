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
## Shell helper

There are some helper scripts in the root of the project:

- ``environment_load_as_vars.sh``
- ``environment_set_as_sys_vars.sh``

## Sync Git Config

The ```git_config``` command can sync the ```Git/etc``` folder using the following options:

- ``git_config -push``
- ``git_config -pull``