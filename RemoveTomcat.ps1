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
Write-Host "RemoveTomcat.ps1"`r

#Removes the service
cmd.exe /c "C:\Program Files\Apache Software Foundation\Tomcat9.0\bin\Service.bat" Remove
Start-Sleep -Seconds 5

#Removes the Environment Variable for CATALINA_HOME
[System.Environment]::SetEnvironmentVariable("CATALINA_HOME", $null, "machine")
Start-Sleep -Seconds 5

#Deletes Tomcats folder and files
Remove-Item -Path "C:\Program Files\Apache Software Foundation" -Recurse
Start-Sleep -Seconds 5

Write-Host "Please check logs at C:\Logs\PowershellLogs.log"
Write-Host "+-----------------------End Script---------------------------+"`r
Stop-Transcript