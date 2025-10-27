@echo off
cd /d "%~dp0
vs_SSMS.exe --quiet --norestart
Timeout /t 600
powershell.exe -executionpolicy Bypass -file .\CreateSQLShortcut.ps1