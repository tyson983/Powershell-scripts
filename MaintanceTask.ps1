if (!(Test-Path -Path "C:\Install"))
{
    new-item -ItemType Directory -path "C:\Install" -Force
}

Start-Transcript -Path C:\Install\MaintenanceLog.txt -Append
$currentDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "+-------------------------Begin Script-------------------------------"`r
Write-Host "MaintenanceLogTasks.ps1"`r

# Function to run a command and return its output
function Run-Command {
    param (
        [string]$command,
        [string]$arguments
    )
    $output = & $command $arguments.Split(" ")
    if ($DebugMode) {
        Write-Host "Debug: Full output of '$command $arguments':" -ForegroundColor Magenta
        $output | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
    }
    return $output
}

Write-host "Starting monthly maintenance at $currentDate" -ForegroundColor Yellow

#Task 1: scan your system files and restore any corrupted or missing files.
Run-Command "sfc" "/Scannow"

#Task 2: #Run Windows Update troubleshooter
Get-TroubleshootingPack -Path C:\Windows\diagnostics\system\WindowsUpdate | Invoke-TroubleshootingPack -Unattended

#Task 3: #Run DISM
Repair-WindowsImage -RestoreHealth -NoRestart -Online 

#Task 4: #Check for Feature Update blocks
If(!(Get-Module | Where {$_.Name -eq 'PSWindowsUpdate'})){
    set-executionpolicy bypass -force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    If(!(Get-PackageProvider | Where {$_.Name -eq 'NuGet' -and $_.Version -gt '2.8.5.201'})){
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ForceBootstrap -Confirm:$false
}}
$CheckPSWindowsUpdate = Get-InstalledModule
if  ($CheckPSWindowsUpdate.Name -eq "PSWindowsUpdate")
    {Write-Host "PSWindowsUpdate module found" -ForegroundColor Yellow} 
else{
    Write-Host "Installing PSWindowsUpdate module" -ForegroundColor Yellow
    Install-Module PSWindowsUpdate -Force -Verbose -ErrorAction SilentlyContinue
    }
Import-Module PSWindowsUpdate -Verbose
try {
    Write-Output "Resetting Windows Update Components" -ForegroundColor Yellow
    Reset-WUComponents -Verbose -ErrorAction SilentlyContinue
    }
catch {Write-Output "An error occurred while resetting Windows Update Components: $_" -ForegroundColor Red} 
# Check for Windows updates
try {
    Write-Output "Checking for Windows updates" -ForegroundColor Yellow
    Get-WindowsUpdate -Install -AcceptAll -UpdateType Software -IgnoreReboot -Verbose -ErrorAction SilentlyContinue
    }
catch {Write-Output "An error occurred while checking for Windows updates: $_" -ForegroundColor Red} 

Write-host "Ending monthly maintenance at $currentDate" -ForegroundColor Yellow

Write-Host "+-------------------------End Script-------------------------------"`r
Stop-Transcript