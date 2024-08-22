if (!(Test-Path -Path "C:\Install\Icons"))
{
    new-item -ItemType Directory -path "C:\Install\Icons" -Force
}

Start-Transcript -Path C:\Install\IntunePowershellScript.log -Append

Write-Host "+-------------------------Begin Script-------------------------------"`r
Write-Host "TaskScheduler-AutologonSales.ps1"`r



Write-Host "+-------------------------End Script-------------------------------"`r
Stop-Transcript