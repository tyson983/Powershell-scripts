# Check if the directory exists; if not, create it
if (!(Test-Path -Path "C:\Install")) {
    New-Item -ItemType Directory -Path "C:\Install" -Force
}

# Start logging the script's output to a log file
Start-Transcript -Path C:\Install\IntunePowershellScript.log -Append

# Script Header
Write-Host "+-------------------------Begin Script-------------------------------"
Write-Host "UninstallintelDriver.ps1"

$Icpsinstaller = get-windowsdriver -Online | where {$_.ClassName -like "ICPS" -and $_.OriginalFileName -match "icps_install_driver.inf"} | select Driver
$IcpsSoft = get-windowsdriver -Online | where {$_.ClassName -like "SoftwareComponent" -and $_.OriginalFileName -match "icpscomponent.inf"} | select Driver

# Check for pnputil.exe in System32 and SysWOW64 directories
$pnputilExists = $false

if ((get-windowsdriver -Online | where {$_.ClassName -like "ICPS" -and $_.OriginalFileName -match "icps_install_driver.inf"}) -and (get-windowsdriver -Online -All | where {$_.ClassName -like "SoftwareComponent" -and $_.OriginalFileName -match "icpscomponent.inf"})) {
# Check in System32
    if (Test-Path -Path "$env:SystemRoot\System32\pnputil.exe") {
        $pnputilExists = $true
        Start-Process -Verb RunAs -FilePath "$env:SystemRoot\System32\pnputil.exe" -ArgumentList "/delete-driver", "$Icpsinstaller", "/Uninstall", "/force"
        Start-Process -Verb RunAs -FilePath "$env:SystemRoot\System32\pnputil.exe" -ArgumentList "/delete-driver", "$IcpsSoft", "/Uninstall", "/force"
        Write-Output "Drivers the $Icpsinstaller and $IcpsSoft have been uninstalled using pnputil.exe from System32."
        Exit 0
    } else {
        # If pnputil.exe was not found
        Write-Output "ERROR: pnputil.exe was not found on this system. Unable to uninstall drivers."
        Exit 1
    }
} else { 
Write-Output "Intel Connectivity Performance Suite is not installed on this device."
exit 0
 
}

# Script Footer
Write-Host "+-------------------------End Script-------------------------------"

# Stop logging the script's output
