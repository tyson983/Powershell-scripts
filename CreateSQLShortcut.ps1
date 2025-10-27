if (Test-Path "$env:PUBLIC\Desktop\SQL Server Management Studio 21.lnk"){
    Write-Output "Shortcut is already created."
    exit 0
}
else {
    Write-Output "Creating shortcuts for SQL Server Management Studio."

    $ShortcutPath = "$env:PUBLIC\Desktop\SQL Server Management Studio 21.lnk" 
    $TargetPath = "C:\Program Files\Microsoft SQL Server Management Studio 21\Release\Common7\IDE\SSMS.exe" 
    $WshShell = New-Object -ComObject WScript.Shell 
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath) 
    $Shortcut.TargetPath = $TargetPath 
    $Shortcut.Save()

    $ShortcutPath = "$env:PUBLIC\Desktop\SQL Server Profiler 21.lnk" 
    $TargetPath = "C:\Program Files\Microsoft SQL Server Management Studio 21\Release\Common7\PROFILER.exe" 
    $WshShell = New-Object -ComObject WScript.Shell 
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath) 
    $Shortcut.TargetPath = $TargetPath 
    $Shortcut.Save()

    $ShortcutPath = "$env:PUBLIC\Desktop\Database Engine Tuning Advisor 21.lnk" 
    $TargetPath = "C:\Program Files\Microsoft SQL Server Management Studio 21\Release\Common7\DTASHELL.exe"
    $WshShell = New-Object -ComObject WScript.Shell 
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath) 
    $Shortcut.TargetPath = $TargetPath 
    $Shortcut.Save()
    exit 0
}