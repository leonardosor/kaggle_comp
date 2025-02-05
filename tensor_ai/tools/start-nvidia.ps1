# Set the CHIPSETMODE environment variable
$env:CHIPSETMODE='NVIDIA'

# Create the PowerShell modules directory if it doesn't exist
$modulesPath = "$home\Documents\WindowsPowerShell\Modules"
$null = New-Item -ItemType Directory -Force -Path $modulesPath

# Use the current location instead of Split-Path
$sourceDirectory = $PWD.Path
$null = Copy-Item -Path (Join-Path $sourceDirectory ".\") -Destination $modulesPath -Force -Recurse

# Import the module
Import-Module -DisableNameChecking -Force tensor_ai

Write-Host "`nSystem Ready $([char]0x2588)"