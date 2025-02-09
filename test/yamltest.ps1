# Read the YAML file
$path = Join-Path $env:SETUP_PROJ "src\config.yaml"
$yamlContent = Get-Content -Raw -Path $path
$yamlContent = [regex]::replace($yamlContent, '\$\{(.*?)\}', {
    param($match)
    $envVarName = $match.Groups[1].Value
    return [System.Environment]::GetEnvironmentVariable($envVarName)
})
# Write-Host $yamlContent
# Convert YAML to PowerShell object
$parsedData = ConvertFrom-Yaml -Yaml $yamlContent

# Display the parsed object
Write-Host $parsedData

foreach ($key in $parsedData.Keys)
{
    $value = $parsedData[$key]
    Write-Host "$key : $value"
}

Write-Host $parsedData.tasks

foreach ($item in $parsedData.tasks)
{
    foreach ($item2 in $item.actions)
    {
        Write-Host $item2.Keys
        Write-Host $item2.args
        foreach ($item3 in $item2.args)
        {

            Write-Host 'i'
            Write-Host $item3.Keys

            return $item3 | Get-Member -MemberType Properties
        }
    }
}

