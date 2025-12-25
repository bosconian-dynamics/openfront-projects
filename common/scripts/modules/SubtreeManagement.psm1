# SubtreeManagement.psm1
# Generic PowerShell module for managing git subtrees in the monorepo

<#
.SYNOPSIS
Pulls updates from a subtree remote.

.PARAMETER Prefix
The path to the subtree relative to repo root (e.g., "external/OpenFrontIO")

.PARAMETER Remote
The git remote name to pull from

.PARAMETER Branch
The branch name to pull from (default: "main")
#>
function Invoke-SubtreePull {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Prefix,
        
        [Parameter(Mandatory=$true)]
        [string]$Remote,
        
        [Parameter(Mandatory=$false)]
        [string]$Branch = "main"
    )
    
    Write-Host "Pulling subtree updates from $Remote/$Branch into $Prefix..." -ForegroundColor Cyan
    git subtree pull --prefix=$Prefix $Remote $Branch --squash
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Subtree pull completed successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Subtree pull failed" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

<#
.SYNOPSIS
Pushes subtree changes to a remote.

.PARAMETER Prefix
The path to the subtree relative to repo root (e.g., "external/OpenFrontIO")

.PARAMETER Remote
The git remote name to push to

.PARAMETER Branch
The branch name to push to (default: "main")
#>
function Invoke-SubtreePush {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Prefix,
        
        [Parameter(Mandatory=$true)]
        [string]$Remote,
        
        [Parameter(Mandatory=$false)]
        [string]$Branch = "main"
    )
    
    Write-Host "Pushing subtree changes from $Prefix to $Remote/$Branch..." -ForegroundColor Cyan
    git subtree push --prefix=$Prefix $Remote $Branch
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Subtree push completed successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Subtree push failed" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

<#
.SYNOPSIS
Adds a version field to package.json for Rush compatibility.

.PARAMETER PackageJsonPath
The path to the package.json file

.PARAMETER Version
The version string to add (default: "0.0.0-external")
#>
function Add-PackageVersion {
    param(
        [Parameter(Mandatory=$true)]
        [string]$PackageJsonPath,
        
        [Parameter(Mandatory=$false)]
        [string]$Version = "0.0.0-external"
    )
    
    if (-not (Test-Path $PackageJsonPath)) {
        Write-Host "✗ package.json not found at: $PackageJsonPath" -ForegroundColor Red
        exit 1
    }
    
    $json = Get-Content $PackageJsonPath -Raw | ConvertFrom-Json
    
    # Check if version already exists
    if ($json.PSObject.Properties.Name -contains "version") {
        Write-Host "⚠ Version field already exists in package.json" -ForegroundColor Yellow
        return
    }
    
    # Add version and private fields
    $json | Add-Member -NotePropertyName "version" -NotePropertyValue $Version -Force
    $json | Add-Member -NotePropertyName "private" -NotePropertyValue $true -Force
    
    # Convert back to JSON with proper formatting
    $jsonString = $json | ConvertTo-Json -Depth 100
    Set-Content $PackageJsonPath $jsonString
    
    Write-Host "✓ Added version: $Version and private: true to package.json" -ForegroundColor Green
}

<#
.SYNOPSIS
Removes version and private fields from package.json.

.PARAMETER PackageJsonPath
The path to the package.json file
#>
function Remove-PackageVersion {
    param(
        [Parameter(Mandatory=$true)]
        [string]$PackageJsonPath
    )
    
    if (-not (Test-Path $PackageJsonPath)) {
        Write-Host "✗ package.json not found at: $PackageJsonPath" -ForegroundColor Red
        exit 1
    }
    
    $json = Get-Content $PackageJsonPath -Raw | ConvertFrom-Json
    
    # Remove version and private if they exist
    if ($json.PSObject.Properties.Name -contains "version") {
        $json.PSObject.Properties.Remove("version")
        Write-Host "✓ Removed version field from package.json" -ForegroundColor Green
    }
    
    if ($json.PSObject.Properties.Name -contains "private") {
        $json.PSObject.Properties.Remove("private")
        Write-Host "✓ Removed private field from package.json" -ForegroundColor Green
    }
    
    # Convert back to JSON with proper formatting
    $jsonString = $json | ConvertTo-Json -Depth 100
    Set-Content $PackageJsonPath $jsonString
}

Export-ModuleMember -Function Invoke-SubtreePull, Invoke-SubtreePush, Add-PackageVersion, Remove-PackageVersion
