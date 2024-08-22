$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -like "Spring*"}
$MyApp.Uninstall()
