if (!(Test-Path -Path "C:\Install\Icons"))
{
    new-item -ItemType Directory -path "C:\Install\Icons" -Force
}

Start-Transcript -Path C:\Install\IntunePowershellScript.log -Append

Write-Host "+-------------------------Begin Script-------------------------------"`r
Write-Host "CopyTeemTalkPOS.ps1"`r

copy-Item -path '.\TeemTalk' -Destination 'C:\install' -recurse

Write-Host "+-------------------------End Script-------------------------------"`r
Stop-Transcript