#!/usr/bin/env pwsh

# PowerShell script to check if a password has been compromised using Have I Been Pwned API
# Uses SHA-1 hash and k-anonymity to protect password privacy

[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [string]$Password
)

# Function to display usage
function Show-Usage {
    Write-Host "Usage: pwned-password-checker.ps1 [password]"
    Write-Host "If password is not provided, you'll be prompted to enter it securely"
    exit 1
}

# Function to get SHA-1 hash
function Get-SHA1Hash {
    param([string]$InputString)
    
    $sha1 = [System.Security.Cryptography.SHA1]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
    $hashBytes = $sha1.ComputeHash($bytes)
    $hash = [System.BitConverter]::ToString($hashBytes) -replace '-'
    $sha1.Dispose()
    return $hash.ToUpper()
}

# Get password from parameter or prompt securely
if ([string]::IsNullOrEmpty($Password)) {
    $SecurePassword = Read-Host -Prompt "Enter password to check" -AsSecureString
    # Convert SecureString to plain text for processing
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
    $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
}

# Validate password is not empty
if ([string]::IsNullOrEmpty($Password)) {
    Write-Host "Error: Password cannot be empty" -ForegroundColor Red
    exit 1
}

try {
    # Generate SHA-1 hash of the password
    $hash = Get-SHA1Hash -InputString $Password
    
    # Get first 5 characters for k-anonymity
    $hashPrefix = $hash.Substring(0, 5)
    
    # Get remaining characters to search for
    $hashSuffix = $hash.Substring(5)
    
    Write-Host "Checking password against Have I Been Pwned database..."
    
    # Make API call to get compromised hashes with same prefix
    $apiUrl = "https://api.pwnedpasswords.com/range/$hashPrefix"
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get -ErrorAction Stop
    
    # Check if our hash suffix is in the response
    $foundMatch = $false
    $breachCount = 0
    
    foreach ($line in $response -split "`n") {
        if ($line.StartsWith($hashSuffix + ":")) {
            $foundMatch = $true
            $breachCount = [int]($line.Split(":")[1].Trim())
            break
        }
    }
    
    if ($foundMatch) {
        Write-Host "⚠️  WARNING: This password has been found in data breaches!" -ForegroundColor Yellow
        Write-Host "   It has appeared $breachCount times in compromised password lists." -ForegroundColor Yellow
        Write-Host "   You should change this password immediately." -ForegroundColor Yellow
        exit 2
    } else {
        Write-Host "✅ Good news! This password has not been found in any known data breaches." -ForegroundColor Green
        Write-Host "   However, you should still use a strong, unique password." -ForegroundColor Green
        exit 0
    }
}
catch {
    Write-Host "Error: Failed to connect to Have I Been Pwned API" -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    # Clear password from memory for security
    if ($Password) {
        $Password = $null
        [System.GC]::Collect()
    }
}