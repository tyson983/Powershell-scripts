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
Write-Host "InstallTomcat.ps1"`r

$Currentuser = (Get-CimInstance Win32_ComputerSystem).UserName

#Creates folder for Tomcat files
if (!(Test-path -Path "C:\Program Files\Apache Software Foundation")) 
{
#Creates folder if folder does exist
    Write-Host "Creating the folder for Tomcat..."
    New-Item -Path "C:\Program Files\Apache Software Foundation" -ItemType Directory -force 



}

Start-Sleep -Seconds 3

#Copy contents of Tomcat 11 zips to Apache Software Foundation folder
if (!(Test-path -Path "C:\Program Files\Apache Software Foundation\Tomcat9.0")) 
{
#Creates folder if folder does exist
    Write-Host "Copying Tomcat 9.0.111 files..."
    Copy-Item -Path ".\Tomcat9.0" -Destination "C:\Program Files\Apache Software Foundation\Tomcat9.0" -Recurse
}

Start-Sleep -Seconds 3

#Sets the Environment Variable for CATALINA_HOME
Write-Host "Setting the CATALINA_HOME to C:\Program Files\Apache Software Foundation\Tomcat9.0"
[System.Environment]::SetEnvironmentVariable("CATALINA_HOME", "C:\Program Files\Apache Software Foundation\Tomcat9.0", "Machine") 

Start-Sleep -Seconds 3

# Define the new path to add
$newPath = "%CATALINA_HOME%\bin"

# Get the current PATH environment variable for the machine
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

# Check if the new path is already in the PATH variable
if ($currentPath -notlike "*$newPath*") {
    # If the new path is not in the PATH variable, add it
    $newPathValue = "$currentPath;$newPath"

    try {
        # Set the new PATH environment variable
        [System.Environment]::SetEnvironmentVariable("Path", $newPathValue, [System.EnvironmentVariableTarget]::Machine)
        Write-Output "The path has been added successfully."
    } catch {
        Write-Error "Failed to set the environment variable: $_"
        Exit 1
    }
} else {
    Write-Output "The path is already in the PATH variable."
}

start-sleep -second 3

# Define the new path to add
$newPath = "%JAVA_HOME%\bin"

# Get the current PATH environment variable for the machine
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

# Check if the new path is already in the PATH variable
if ($currentPath -notlike "*$newPath*") {
    # If the new path is not in the PATH variable, add it
    $newPathValue = "$currentPath;$newPath"

    try {
        # Set the new PATH environment variable
        [System.Environment]::SetEnvironmentVariable("Path", $newPathValue, [System.EnvironmentVariableTarget]::Machine)
        Write-Output "The path has been added successfully."
    } catch {
        Write-Error "Failed to set the environment variable: $_"
        Exit 1
    }
} else {
    Write-Output "The path is already in the PATH variable."
}

Start-Sleep -Seconds 3

#Give current user full Control of the Apache Software Foundation folder
Write-Host "Giving the current user 'Full Control' permissions to C:\Program Files\Apache Software Foundation\Tomcat9.0..."
$ACL = Get-ACL -Path "C:\Program Files\Apache Software Foundation\Tomcat9.0"
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$Currentuser","FullControl","Allow")
$ACL.SetAccessRule($AccessRule)
$ACL | Set-Acl -Path "C:\Program Files\Apache Software Foundation\Tomcat9.0"

#Check permissions of the Apache Software folder
(Get-ACL -Path "C:\Program Files\Apache Software Foundation\Tomcat9.0").Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize
 
start-sleep -second 3


if (Test-path -Path "C:\Program Files\Apache Software Foundation\Tomcat9.0\bin\service.bat")
{
    #Installs Tomcat as a service
    Write-Host "Installing Tomcat service..."
    Start-Job -ScriptBlock {cmd.exe /c "C:\Program Files\Apache Software Foundation\Tomcat9.0\bin\service.bat" "install"} -WarningAction SilentlyContinue
    $service = Get-Service -Name "Tomcat9"
    Start-Sleep -Seconds 10
    if ($service -eq $null) 
    {
        #Check if service exists
        Write-Host "Tomcat9 service does not exist."
        Exit 1
        
    } else {
        #Action when all if and elseif conditions are false
        Write-Host "Tomcat 9 service exists."
    }

}

Write-Host "Tomcat9 nstallation Completed"

start-sleep -second 3

#Sets service to automatic
Write-Host "Setting Tomcat9 Service to automatic"
Set-Service -Name "Tomcat9" -StartupType "Automatic" -Force


Write-Host "Please check logs at C:\Logs\PowershellLogs.log"
Write-Host "+-----------------------End Script---------------------------+"`r
Stop-Transcript
Exit 0