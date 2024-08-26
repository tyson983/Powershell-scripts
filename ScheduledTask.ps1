#Creates Scheduled Task

#Enter the path to the executable
$action = New-ScheduledTaskAction -Execute "Enter the path" -Argument "/S"

#Enter when Task is Triggered
$trigger = New-ScheduledTaskTrigger -Daily -At 11:00PM

#Enter the priority. The highest priority executes first.
$STSet = New-ScheduledTaskSettingsSet -Priority 8

#The userid the will run the script. Leave as "system" to run as local admin.
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest

#Creates Task
$Task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $STSet
Register-ScheduledTask "Name of task" -InputObject $task