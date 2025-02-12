# Check if the directory C:\Install exists, if not create it
if (!(Test-Path -Path "C:\Install"))
{
   new-item -ItemType Directory -path "C:\Install" -Force
}

# Start transcription for logging
Start-Transcript -Path C:\Install\BitlockerToubleshooting.log -Append

# Initial script output
Write-Host "+-------------------------Begin Script-------------------------------"`r
Write-Host "InstallBitlocker.ps1 "`r
Write-Host " Installing Bitlocker... "`r

# Set error action preference to stop on errors
$ErrorActionPreference = "Stop"

########### Start Global Variable Section ###########
$Store = ($env:COMPUTERNAME.Split("-")[0]).ToUpper()
$LocalOsDrive = "C"
$BitLockerShare = "\\ivt-nas\Software\BitLocker Keys"
$TestFile = "AutomatedBuild.log"
$OsPasswordFile = $($Store + "-" + $LocalOsDrive + ".txt")
########### End Global Variable Section #############

# Start script execution

$installstate = (Get-WindowsFeature -Name Bitlocker | Select-Object installstate).installstate

if (!($installstate -eq "installed")) {
    # Start the script by installing BitLocker feature with all subfeatures and management tools
    Install-WindowsFeature BitLocker -IncludeAllSubFeature -IncludeManagementTools -Restart
}
Else {
    Write-Output "Bitlocket is already installed."
}
# Wait for the system to restart if necessary (the -Restart option will trigger a restart)
Start-Sleep -Seconds 90  # Give the system some time to restart and apply changes

Write-Output "Server: $($env:COMPUTERNAME)"

Write-Output "    DEBUG: Validating Access to BitLockerShare"
try{
    # Log the attempt to access the BitLocker share
    $logString = $($Store + "  -  " + $LocalOsDrive + " Drive  -  " + $(Get-Date).ToString())
    $logString | Out-File -FilePath $($BitLockerShare + "\" + $TestFile) -Encoding ascii -Append
    $recoveryFile = $($BitLockerShare + "\" + $OsPasswordFile)
} catch{
    Write-Output "Encountered issue: $($PSItem.ToString()) While accessing share: $BitLockerShare"
}

Write-Output "    DEBUG: Enable BitLocker on $LocalOsDrive Drive"
# Add BitLocker protector and start encryption
$BitlockerInfo = (Get-BitLockerVolume -MountPoint "${LocalOsDrive}:")
$Bitlockerpass = $Bitlockerinfo.KeyProtector.Recoverypassword
if (!($bitlockerpass)) {
    Add-BitLockerKeyProtector -MountPoint "${LocalOsDrive}:" -RecoveryPasswordProtector 3> $recoveryFile
    Enable-BitLocker -MountPoint "${LocalOsDrive}:" -EncryptionMethod Aes256 -TpmProtector
    Start-Sleep 90  # Wait for encryption to start
}
Else {

Write-Output "Bitlocker Recovery Password is already present."

}

Write-Output "    DEBUG: Backup BitLocker Recovery Key for $LocalOsDrive Drive"
# Retrieve and backup the BitLocker recovery key
$bitLockerKey = Get-BitLockerVolume -MountPoint "${LocalOsDrive}:"
$keyProtector = $bitLockerKey.KeyProtector | Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"}
Backup-BitLockerKeyProtector -MountPoint "${LocalOsDrive}:" -KeyProtectorId $keyProtector.KeyProtectorId | Format-List

# Restart the system after the script completes
Restart-Computer -Force

# Final output marking the end of the script
Write-Host "+-------------------------End Script-------------------------------"`r
Write-Host " Bitlocker is now installed. "`r

# Stop the transcription
Stop-Transcript