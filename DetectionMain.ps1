# Define the path to the MaintenanceLog.txt file
$filePath = "C:\install\MaintenanceLog.txt"

# Check if the file exists
if (Test-Path $filePath) {
    # Get the file's last modified time
    $file = Get-Item $filePath
    $lastModifiedTime = $file.LastWriteTime

    # Get the current date
    $currentDate = Get-Date

    # Calculate the difference between the current date and the last modified time of the file
    $timeDifference = $currentDate - $lastModifiedTime

    # Check if the file has been modified in the last 30 days
    if ($timeDifference.Days -gt 30) {
        Write-Host "The file has not been modified in the last 30 days."
        exit 1  # Exit with code 1 if the file hasn't been modified in the last 30 days
    } 
    else {
        Write-Host "The file has been modified within the last 30 days."
        exit 0  # Exit with code 0 if the file has been modified within the last 30 days
    }
}
else {
    Write-Host "The file does not exist."
    exit 1  # Exit with code 1 if the file doesn't exist
}