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

#Test path for intel Connectivity driver oem52.inf
if(Test-path -Path "$env:SystemRoot\System32\DriverStore\FileRepository\icps_install_driver.inf_amd64_5c7778c07c99c986\icps_install_driver.inf"){

# Check in System32
    if (Test-Path -Path "$env:SystemRoot\System32\pnputil.exe") {
        $pnputilExists = $true
        Start-Process -Verb RunAs -FilePath "$env:SystemRoot\System32\pnputil.exe" -ArgumentList "/delete-driver", "oem52.inf", "/Uninstall"
        Write-Output "Driver the oem52.inf have been uninstalled using pnputil.exe from System32."
    } else {
        # If pnputil.exe was not found
        Write-Output "ERROR: pnputil.exe was not found on this system. Unable to uninstall drivers."
        }
} else { Write-Output "Intel Connectivity driver oem52.inf was not found."

}

#Test path for intel Connectivity driver oem7.inf and oem175.inf
if(Test-path -Path "$env:SystemRoot\System32\DriverStore\FileRepository\icpscomponent.inf_amd64_28a25ea3f29a632c\icpscomponent.inf"){

# Check in System32
    if (Test-Path -Path "$env:SystemRoot\System32\pnputil.exe") {
        $pnputilExists = $true
        Start-Process -Verb RunAs -FilePath "$env:SystemRoot\System32\pnputil.exe" -ArgumentList "/delete-driver", "oem7.inf", "/Uninstall"
        Start-Process -Verb RunAs -FilePath "$env:SystemRoot\System32\pnputil.exe" -ArgumentList "/delete-driver", "oem175.inf", "/Uninstall"
        Write-Output "Driver the oem7.inf have been uninstalled using pnputil.exe from System32."
    } else {
        # If pnputil.exe was not found
        Write-Output "ERROR: pnputil.exe was not found on this system. Unable to uninstall drivers."
        }
} else { Write-Output "Intel Connectivity driver oem7.inf and oem175.inf was not found."

}

#Test path for intel Connectivity driver oem176.inf
if(Test-path -Path "$env:SystemRootSystem32\DriverStore\FileRepository\icpscomponent.inf_amd64_614f168f1cb5f632\icpscomponent.inf"){

# Check in System32
    if (Test-Path -Path "$env:SystemRoot\System32\pnputil.exe") {
        $pnputilExists = $true
        Start-Process -Verb RunAs -FilePath "$env:SystemRoot\System32\pnputil.exe" -ArgumentList "/delete-driver", "oem176.inf", "/Uninstall"
        Write-Output "Driver the oem176.inf have been uninstalled using pnputil.exe from System32."
    } else {
        # If pnputil.exe was not found
        Write-Output "ERROR: pnputil.exe was not found on this system. Unable to uninstall drivers."
        }
} else { Write-Output "Intel Connectivity driver oem176.inf was not found."

}

#Test path for intel Connectivity driver oem203.inf
if(Test-path -Path "$env:SystemRootSystem32\DriverStore\FileRepository\icps_install_driver.inf_amd64_5c7778c07c99c986\icps_install_driver.inf"){

# Check in System32
    if (Test-Path -Path "$env:SystemRoot\System32\pnputil.exe") {
        $pnputilExists = $true
        Start-Process -Verb RunAs -FilePath "$env:SystemRoot\System32\pnputil.exe" -ArgumentList "/delete-driver", "oem203.inf", "/Uninstall"
        Write-Output "Driver the oem176.inf have been uninstalled using pnputil.exe from System32."
    } else {
        # If pnputil.exe was not found
        Write-Output "ERROR: pnputil.exe was not found on this system. Unable to uninstall drivers."
        }
} else { Write-Output "Intel Connectivity driver oem203.inf was not found."

}

#Test path for intel Connectivity driver oem204.inf
if(Test-path -Path "$env:SystemRootSystem32\DriverStore\FileRepository\icpscomponent.inf_amd64_f92eefc3091f1964\icpscomponent.inf"){

# Check in System32
    if (Test-Path -Path "$env:SystemRoot\System32\pnputil.exe") {
        $pnputilExists = $true
        Start-Process -Verb RunAs -FilePath "$env:SystemRoot\System32\pnputil.exe" -ArgumentList "/delete-driver", "oem204.inf", "/Uninstall"
        Write-Output "Driver the oem176.inf have been uninstalled using pnputil.exe from System32."
    } else {
        # If pnputil.exe was not found
        Write-Output "ERROR: pnputil.exe was not found on this system. Unable to uninstall drivers."
        }
} else { Write-Output "Intel Connectivity driver oem204.inf was not found."

}


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
