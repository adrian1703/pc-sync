# Read the YAML file
$path = Join-Path $env:SETUP_PROJ "src\config.yaml"
$yamlContent = Get-Content -Raw -Path $path
$yamlContent = [regex]::replace($yamlContent, '\$\{(.*?)\}', {
    param($match)
    $envVarName = $match.Groups[1].Value
    return [System.Environment]::GetEnvironmentVariable($envVarName)
})
Write-Host $yamlContent
# Convert YAML to PowerShell object
$parsedData = ConvertFrom-Yaml -Yaml $yamlContent

# Display the parsed object
Write-Host $parsedData

foreach ($key in $parsedData.Keys)
{
    $value = $parsedData[$key]
    Write-Host "$key : $value"
}

Write-Host $parsedData.rider.Keys

foreach ($item in $parsedData.schema.stages)
{
    Write-Host $item.name
    Write-Host $item.prio
}
Write-Host $parsedData.schema.stages
$parsedData.schema.stages

