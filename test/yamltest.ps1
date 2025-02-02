# Read the YAML file
$path = Join-Path $env:SETUP_PROJ "src\config.yaml"
$yamlContent = Get-Content -Raw -Path $path

# Convert YAML to PowerShell object
$parsedData = ConvertFrom-Yaml -Yaml $yamlContent

# Display the parsed object
$parsedData