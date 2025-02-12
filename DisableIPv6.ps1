start-transcript -path C:\Install\IntunePowershellScript.log -append

if (!(Test-Path -Path "C:\Install"))
{
    new-item -ItemType Directory -path "C:\Install" -Force
}

Write-Host "+-------------------------Begin Script-------------------------------"`r
Write-Host " Running DisableIPv6.ps1 "`r

New-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\' -Name  'DisabledComponents' -Value '0xffffffff' -PropertyType 'DWord'

Write-Host "+-------------------------End Script-------------------------------"`r

stop-transcript