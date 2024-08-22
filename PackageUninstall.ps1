if (!(Test-Path -Path "C:\Install\Icons"))
{
    new-item -ItemType Directory -path "C:\Install\Icons" -Force
}

Start-Transcript -Path C:\Install\IntunePowershellScript.log -Append

Write-Host "+-------------------------Begin Script-------------------------------"`r
Write-Host "PackageUninstall.ps1"`r

Get-Package -Name "Spring*" | Uninstall-Package

Write-Host "+-------------------------End Script-------------------------------"`r
Stop-Transcript