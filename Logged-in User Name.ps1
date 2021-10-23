$curhostname=$env:computername
$env:HostIP = (
Get-NetIPConfiguration |
Where-Object {
$_.IPv4DefaultGateway -ne $null -and
$_.NetAdapter.Status -ne "Disconnected"
}
).IPv4Address.IPAddress
$currus_cn=(get-aduser $env:UserName -properties *).DistinguishedName
$ADComp = Get-ADComputer -Identity $curhostname
$ADComp.ManagedBy = $currus_cn
$ADComp.extensionAttribute1 = $env:HostIP
Set-ADComputer -Instance $ADComp

#http://woshub.com/using-powershell-active-directory-module-without-installing-rsat/