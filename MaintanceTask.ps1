if (!(Test-Path -Path "C:\Install"))
{
    new-item -ItemType Directory -path "C:\Install" -Force
}

Start-Transcript -Path C:\Install\MaintenanceLog.txt -Append
$currentDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "+-------------------------Begin Script-------------------------------+"`r
Write-Host "MaintenanceLogTasks.ps1"`r

# Run a command
function RunCommand([ScriptBlock] $command) {

    # Run the command and write the output to the window and to a variable ("SFC" formatting)
    $stringcommand = $command.ToString()
    if (
        $stringcommand -match "^SFC$" -or
        $stringcommand -match "^SFC.exe$" -or
        $stringcommand -match "^SFC .*$" -or
        $stringcommand -match "^SFC.exe .*$"
    ) {
        $oldEncoding = [console]::OutputEncoding
        [console]::OutputEncoding = [Text.Encoding]::Unicode
        $command = [ScriptBlock]::Create("(" + $stringcommand + ")" + " -join ""`r`n"" -replace ""`r`n`r`n"", ""`r`n""")
        & ($command) 2>&1 | Tee-Object -Variable out_content
        [console]::OutputEncoding = $oldEncoding

    # Run the command and write the output to the window and to a variable (normal formatting)
    } else {
        & ($command) 2>&1 | Tee-Object -Variable out_content
    }

    # Manipulate output variable, write it to a file...
    # ...
    return
}


Write-host "Starting monthly maintenance at $currentDate"-ForegroundColor Yellow
Write-Host "+------------------------------------------------------------+"`r -ForegroundColor Yellow

#Task 1:  Run System File Checker (SFC)
Write-Host "`nTask 1: Running System File Checker..."-ForegroundColor Cyan

# First, run sfc /verifyonly
$sfcVerifyOutput = RunCommand {sfc /verifyonly}

# Display the value of Output in yellow 
Write-Host "System File Checker Output: $sfcVerifyOutput" -ForegroundColor Yellow

if ($sfcVerifyOutput -match "Windows Resource Protection did not find any integrity violations.") {
    Write-Host "No system file integrity violations found."-ForegroundColor Green
} else {
    Write-Host "Potential system file integrity violations detected. Running full scan and repair..."-ForegroundColor Yellow
    
    # Run sfc /scannow if violations were found
    $sfcScanOutput = RunCommand {sfc /scannow}

    # Display the value of $sfcVerifyOutput in yellow 
    Write-Host "System File Checker Output: $sfcScanOutput" -ForegroundColor Yellow
    if ($sfcScanOutput -match "Windows Resource Protection found corrupt files and successfully repaired them.") {
        Write-Host "Corrupt system files were found and repaired."-ForegroundColor Yellow
        $repairsMade = $true
    } elseif ($sfcScanOutput -match "Windows Resource Protection did not find any integrity violations.") {
        Write-Host "No system file integrity violations found after full scan."-ForegroundColor Green
    } else {
        Write-Host "System File Checker encountered an issue. Please check the logs for more information." -ForegroundColor Red
    }
}

#Task 2: #Run Windows Update troubleshooter
Write-Host "`nTask 2: Running Windows Update Troubleshooting..."-ForegroundColor Cyan
Get-TroubleshootingPack -Path C:\Windows\diagnostics\system\WindowsUpdate | Invoke-TroubleshootingPack -Unattended

#Task 3: #Run DISM
Write-Host "`nTask 3: Running DISM Image Repair..." -ForegroundColor Cyan
$HealthScanOutput = Repair-WindowsImage -CheckHealth -NoRestart -Online

If ($HealthScanOutput.ImageHealthState -like "Healthy") {
   Write-Output "Component store is healthy..."
} else {
   Write-Output "Component store corruption confirmed. Attempting repair..."

   # DISM RestoreHealth
   $DISMOutput = Repair-WindowsImage -RestoreHealth -NoRestart -Online
   
   if ($DISMOutput.ImageHealthState -like "Healthy") {
        Write-Host "Component store repaired successfully." -ForegroundColor Green
   } else {
        Write-Host "Failed to repair component store. Please check the logs for more information."-ForegroundColor Red
        }
    }

#Task 4: #Check for Feature Update blocks
Write-Host "`nTask 4: Checking for Windows Update..."-ForegroundColor Cyan
If(!(Get-Module | Where {$_.Name -eq 'PSWindowsUpdate'})){
    set-executionpolicy bypass -force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    If(!(Get-PackageProvider | Where {$_.Name -eq 'NuGet' -and $_.Version -gt '2.8.5.201'})){
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ForceBootstrap -Confirm:$false
}}
$CheckPSWindowsUpdate = Get-InstalledModule
if  ($CheckPSWindowsUpdate.Name -eq "PSWindowsUpdate")
    {Write-Host "PSWindowsUpdate module found" -ForegroundColor Yellow
    } 
else{
    Write-Host "Installing PSWindowsUpdate module"
    Install-Module PSWindowsUpdate -Force -Verbose -ErrorAction SilentlyContinue
    }
Import-Module PSWindowsUpdate -Verbose
try {
    Write-Output "Resetting Windows Update Components"
    Reset-WUComponents -Verbose -ErrorAction SilentlyContinue
    }
catch {Write-Output "An error occurred while resetting Windows Update Components: $_"
} 
# Check for Windows updates
try {
    Write-Output "Checking for Windows updates" 
    Get-WindowsUpdate -Install -AcceptAll -UpdateType Software -IgnoreReboot -Verbose -ErrorAction SilentlyContinue
    }
catch {Write-Output "An error occurred while checking for Windows updates: $_"
} 

Write-Host "+------------------------------------------------------------+"`r -ForegroundColor Yellow
Write-host "Ending monthly maintenance at $currentDate" -ForegroundColor Yellow

Write-Host "+-------------------------End Script-------------------------------+"`r
Stop-Transcript
