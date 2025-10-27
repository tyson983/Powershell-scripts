@echo off
".\gpg4win-4.4.1.exe" /S
Timeout /t 20
powershell.exe -executionpolicy Bypass -file .\Create_gpg4win_Shortcut.ps1