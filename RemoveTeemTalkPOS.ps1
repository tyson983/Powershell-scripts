if (!(Test-Path -Path "C:\Install\Icons"))
{
    new-item -ItemType Directory -path "C:\Install\Icons" -Force
}

Start-Transcript -Path C:\Install\IntunePowershellScript.log -Append

Write-Host "+-------------------------Begin Script-------------------------------"`r
Write-Host " Running RemoveTeemtalkPOS.ps1"`r

Remove-Item -path 'C:\install\TeemTalk'
Get-Package -Name "TeemTalk for Windows*" | Uninstall-Package

Write-Host "+-------------------------End Script-------------------------------"`r
Stop-Transcript