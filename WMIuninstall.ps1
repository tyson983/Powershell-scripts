if (!(Test-Path -Path "C:\Install\Icons"))
{
    new-item -ItemType Directory -path "C:\Install\Icons" -Force
}

Start-Transcript -Path C:\Install\IntunePowershellScript.log -Append

Write-Host "+-------------------------Begin Script-------------------------------"`r
Write-Host "WMIUninstall.ps1"`r

$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -like "Spring*"}
$MyApp.Uninstall()

Write-Host "+-------------------------End Script-------------------------------"`r
Stop-Transcript