
# Listing device by name
Get-WmiObject Win32_PnPSignedDriver| select devicename| where {$_.devicename -like "Intel(R) Connectivity Performance Suite"}
# Deleting a device by name
(Get-WmiObject Win32_PnPSignedDriver -filter "DeviceName='Intel(R) Connectivity Performance Suite'").delete()