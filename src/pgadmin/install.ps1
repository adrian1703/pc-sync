Import-Module ./src/Utils.psm1

Invoke-Download `
    -t "PGAdmin" `
    -dl "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v8.14/windows/pgadmin4-8.14-x64.exe" `
    -in "pgadmin4-8.14-x64_installer.exe"
