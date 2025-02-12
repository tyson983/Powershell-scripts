# Check if the directory exists; if not, create it
if (!(Test-Path -Path "C:\Install")) {
    New-Item -ItemType Directory -Path "C:\Install" -Force
}

# Start logging the script's output to a log file
Start-Transcript -Path C:\Install\IntunePowershellScript.log -Append

# Script Header
Write-Host "+-------------------------Begin Script-------------------------------"
Write-Host "UninstallintelDriver.ps1"

# Check for pnputil.exe in System32 and SysWOW64 directories
$pnputilExists = $false

# Check in System32
if (Test-Path -Path "$env:SystemRoot\System32\pnputil.exe") {
    $pnputilExists = $true
    Start-Process -Verb RunAs -FilePath "$env:SystemRoot\System32\pnputil.exe" -ArgumentList "/delete-driver", "oem68.inf", "/Uninstall"
    Start-Process -Verb RunAs -FilePath "$env:SystemRoot\System32\pnputil.exe" -ArgumentList "/delete-driver", "oem105.inf", "/Uninstall"
    Write-Output "Drivers have been uninstalled using pnputil.exe from System32."
}

# Check in SysWOW64 if not found in System32
if (!$pnputilExists -and (Test-Path -Path "$env:SystemRoot\SysWOW64\pnputil.exe")) {
    $pnputilExists = $true
    Start-Process -Verb RunAs -FilePath "$env:SystemRoot\SysWOW64\pnputil.exe" -ArgumentList "/delete-driver", "oem68.inf", "/Uninstall"
    Start-Process -Verb RunAs -FilePath "$env:SystemRoot\SysWOW64\pnputil.exe" -ArgumentList "/delete-driver", "oem105.inf", "/Uninstall"
    Write-Output "Drivers have been uninstalled using pnputil.exe from SysWOW64."
}

# If pnputil.exe was not found
if (-not $pnputilExists) {
    Write-Output "ERROR: pnputil.exe was not found on this system. Unable to uninstall drivers."
}

# Script Footer
Write-Host "+-------------------------End Script-------------------------------"

# Stop logging the script's output