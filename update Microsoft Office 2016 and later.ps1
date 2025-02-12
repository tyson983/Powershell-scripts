# PowerShell script to force update for all installed versions of Microsoft Office 2016 and later

# Function to update Office
function Update-Office {
    param (
        [string]$OfficePath
    )
    Write-Output "Updating Office from path: $OfficePath"
    $OfficeUpdateScript = Join-Path -Path $OfficePath -ChildPath "OfficeC2RClient.exe"
    if (Test-Path $OfficeUpdateScript) {
        Start-Process -FilePath $OfficeUpdateScript -ArgumentList "/update user" -Wait
        Write-Output "Office update initiated successfully."
    } else {
        Write-Output "OfficeC2RClient.exe not found at path: $OfficePath"
    }
}

# Paths to check for Office installations
$officePaths = @(
    "C:\Program Files\Common Files\Microsoft Shared\ClickToRun",
    "C:\Program Files (x86)\Common Files\Microsoft Shared\ClickToRun"
)

# Loop through each path and initiate the update
foreach ($path in $officePaths) {
    if (Test-Path $path) {
        Update-Office -OfficePath $path
    } else {
        Write-Output "No Office installation found at path: $path"
    }
}

Write-Output "Office update process completed."