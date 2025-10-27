if (Test-Path "$env:PUBLIC\Desktop\Kleopatra.lnk"){
    Write-Output "Shortcut is already created."
    exit 0
}
else{
    
    Write-Output "Creating shortcut for Kleopatra."

    $ShortcutPath = "$env:PUBLIC\Desktop\Kleopatra.lnk" 
    $TargetPath = "C:\Program Files (x86)\Gpg4win\bin\kleopatra.exe" 
    $WshShell = New-Object -ComObject WScript.Shell 
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath) 
    $Shortcut.TargetPath = $TargetPath 
    $Shortcut.Save()

}