<#
Name:Get device info from Azure AD
Description: This script helps to collect the objectID from Azure AD that will be used to import the objects into Azure AD groups.
Author:Eswar Koneti (@eskonr)
Date:15-Jul-2022
#>
#Get the script location
$scriptpath = $MyInvocation.MyCommand.Path
$directory = Split-Path $scriptpath
#Get the script execution date                  
$date = (Get-Date -f dd-MM-yyyy-hhmmss)
#input the list of devices to retrive the information from AAD.
$input="$directory\Listofdevices.txt"
#Output file for storing the Azure AD device info
$Output="$directory\ObjectIDinfo.csv"
#Check the Azure AD module
if (!(get-module -name *AzureAD*))
{
Write-Host "Azure AD module not installed, installing now" -BackgroundColor Red
Install-Module -Name AzureAD

$Modules = Get-Module -Name *AzureAD*
if ($Modules.count -eq 0)
{
  Write-Host "Unable to install the required modules, please install and run the script again" -BackgroundColor Red
  exit
}
}

#Connect to Azure Active Directory
if (!(Get-AzureADTenantDetail))
{
try
{
Connect-AzureAD
}
catch {
Write-Host "Unable to connect to Azure AD services, exiting script " -ForegroundColor Red
break
}
}
#Read the devices
$deviceList = get-content -Path $input
 foreach ($dev in $deviceList)
 {
 Get-AzureADDevice -SearchString $dev |select DisplayName,ObjectID |Export-Csv $Output -Append -NoTypeInformation
 }

