$ShortcutPath1 = "$env:PUBLIC\Desktop\Kleopatra.lnk" 
Remove-Item $ShortcutPath1

$StartMenuShortcutPath = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Kleopatra.lnk"
Remove-Item $StartMenuShortcutPath