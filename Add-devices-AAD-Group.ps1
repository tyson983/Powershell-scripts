<#
Name:Add the devices to Azure AD security group.
Description: This script helps to add the devices to the Azure AD security groups. For few devices, you can add manually but large set, use GUI or script.
Author:Eswar Koneti (@eskonr)
Date:15-Jul-2022
#>
#Get the script location
$scriptpath = $MyInvocation.MyCommand.Path
$directory = Split-Path $scriptpath
#Get the script execution date                  
$date1 = (Get-Date -f dd-MM-yyyy-hhmmss)
#Input the list of device names along with object ID info.
$input="$directory\Listofdevices.csv"
$log="$directory\add-devices-aad.log"
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
$groupName = read-host -Prompt "Enter the AAD Security group name" #"Intune - Windows Computers - Asia Pilot Non-JP"
if (!(Get-AzureADGroup -SearchString $groupName))
{
write-host "Group name $Groupname not found, exit script" -BackgroundColor red
break
}
"----------------- script started at $date1---------------------" | Out-File $log -Append
try {
    $deviceList = Import-Csv -Path $input
    "-----processing the device count $($devicelist.count) ----------"| Out-File $log -Append
    $groupObj = Get-AzureADGroup -SearchString $groupName
    foreach ($dev in $deviceList)
     {
     $Computer=$dev.DisplayName #computer Name
     $ObjID=$dev.ObjectId #Computer Object ID
           try
{
Add-AzureADGroupMember -ObjectId $groupObj.ObjectId -RefObjectId $ObjID
}
            catch
            {
            "Failed to add device $Computer to the group '$groupName'" | Out-File $log -Append
            }
        }
    
}
catch {
    Write-Host -Message $_ | Out-File $log -Append
}
$date2 = (Get-Date -f dd-MM-yyyy-hhmmss) 
"----------------- script ended at $date2---------------------"| Out-File $log -Append