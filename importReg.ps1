if (!(Test-Path -Path "C:\Install\Drivers\Register_Espon"))
{
    new-item -ItemType Directory -path "C:\Install\Drivers\Register_Epson" -Force
}

Start-Transcript -Path C:\Install\IntunePowershellScript.log -Append

Write-Host "+-------------------------Begin Script-------------------------------"`r
Write-Host "Oposimport.ps1"`r

copy-Item -path '.\Oposdata.reg' -Destination 'C:\install\Drivers\Register_Epson' -recurse
#Start-Process -Verb RunAs -filepath "C:\windows\regedit.exe" -argumentlist @("/S","C:\Install\Drivers\Register_Epson\Oposdata2.reg")
Reg.exe import .\Oposdata.reg /reg:32

Write-Host "+-------------------------End Script---------------------------------"`r
Stop-Transcript