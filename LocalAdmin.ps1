# Define the username and password for the new admin account
$username = "USername"
$password = "YourSecurePasswordHere" | ConvertTo-SecureString -AsPlainText -Force

# Create the new local user account
New-LocalUser -Name $username -Password $password -FullName "Name" -Description "Local admin account"

# Add the new user to the Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $username

Write-Output "Local admin account '$username' has been created and added to the Administrators group."