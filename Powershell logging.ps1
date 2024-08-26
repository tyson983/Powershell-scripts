#Test to see if folder exists
if (!(Test-path -Path "C:\Logs")) 
{
#Creates folder if folder does exist
    new-item -ItemType Directory -Path "C:\Logs" -force 
}

#Creates a log file for powershell output
Start-Transcript -Path C:\Logs\PowershellLogs.log -Append

Write-Host "+-----------------------Begin Script-------------------------+"`r
#Change to the title of the script 
Write-Host "Name of script.ps1"`r

#Script goes here

Write-Host "+-----------------------End Script---------------------------+"`r
Stop-Transcript