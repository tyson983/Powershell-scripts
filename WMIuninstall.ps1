$MyApp = Get-WmiObject -Class win32_product | Where-Object{$_.Name -like "Yakuza"}
$MyApp.Uninstall