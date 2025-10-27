# Ensure the script is run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run with administrative privileges. Please restart PowerShell as Administrator."
    exit 1
}

# Define the feature to enable
$featureNames = @("NetFx3","NetFx4-AdvSrvs","IIS-IIS6ManagementCompatibility","IIS-ASPNET","IIS-ASPNET45") # Replace with the actual feature name you want to enable

#Display Names of Windows features 
#IIS-ASPNET = ASP.NET 3.5
#IIS-ASPNET45 = ASP.NET 4.8
#IIS-IIS6ManagementCompatibility = IIS 6 Management Compatibility
#NetFx3 = Net Framework 3.5
#https://weblog.west-wind.com/posts/2017/may/25/automating-iis-feature-installation-with-powershell

# Enable the Windows optional feature
foreach($featureName in $featureNames) {
    try {
        Enable-WindowsOptionalFeature -Online -FeatureName $featureName -All -NoRestart
        Write-Host "Successfully initiated enablement of feature: $featureName"
    }
    catch {
        Write-Error "Failed to enable feature: $featureName. Error: $($_.Exception.Message)"
    }
}

# Optional: Check if a restart is needed
$featureStatus = Get-WindowsOptionalFeature -Online -FeatureName $featureName
if ($featureStatus.RestartNeeded) {
    Write-Host "A restart is required to complete the installation of $featureName."
    # You can add a command here to initiate a restart, e.g., Restart-Computer -Force
}