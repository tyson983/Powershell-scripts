@echo off
"C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe" uninstall --installpath "C:\Program Files\Microsoft SQL Server Management Studio 21\Release" --quiet
powershell.exe -executionpolicy Bypass -file .\RemoveSQLshortcuts.ps1