# Script to list packages in all Conda environments

# Function to list packages in a specific Conda environment
function Get-CondaEnvironmentPackages {
    param (
        [string]$EnvironmentName
    )

    Write-Host "Packages in environment: $EnvironmentName" -ForegroundColor Green
    try {
        # Use conda list to get all packages in the specified environment
        conda activate $EnvironmentName
        conda list
        conda deactivate
    }
    catch {
        Write-Host "Error accessing environment: $EnvironmentName" -ForegroundColor Red
    }
}

# Get list of all Conda environments
$environments = conda env list | Where-Object { 
    $_ -notmatch 'base' -and 
    $_ -notmatch 'Environments' -and 
    $_ -match '\S'  # Ensure non-empty line
} | ForEach-Object {
    # Extract environment name (first column)
    ($_ -split '\s+')[0]
}

# If no environments found
if ($environments.Count -eq 0) {
    Write-Host "No Conda environments found." -ForegroundColor Yellow
    return
}

# Iterate through each environment and list its packages
foreach ($env in $environments) {
    Write-Host "`n" # Add a blank line between environments
    Get-CondaEnvironmentPackages -EnvironmentName $env
}
