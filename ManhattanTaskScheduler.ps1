if (!(Test-Path -Path "C:\Install\Icons"))
{
    new-item -ItemType Directory -path "C:\Install\Icons" -Force
}

Start-Transcript -Path C:\Install\IntunePowershellScript.log -Append

Write-Host "+-------------------------Begin Script-------------------------------"`r
Write-Host "ManhattanTaskScheduler.ps1"`r

#Creates Scheduled Task
$action = New-ScheduledTaskAction -Execute 'powershell' -Argument '-NoProfile -ExecutionPolicy Unrestricted C:\INTB-store-webview2-234.264.61\Install.ps1'
$trigger = New-ScheduledTaskTrigger -AtLogOn
$STSet = New-ScheduledTaskSettingsSet -Priority 7
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest 
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $STSet
Register-ScheduledTask 'Install Manhattan POS' -InputObject $task


Write-Host "+-------------------------End Script-------------------------------"`r
Stop-Transcript