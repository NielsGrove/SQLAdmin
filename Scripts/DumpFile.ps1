

$DumpFile = (Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl -Name DumpFile).DumpFile
$DumpFile # string (System.String)

#[string]$DumpfileName = 'C:\Windows\MEMORY.DMP'  #default
[string]$DumpfileName = 'F:\MEMORY.DMP'  #custom

Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl -Name DumpFile -Value $DumpfileName
$DumpFile = $null


<#
$OSRecovery = Get-WmiObject -Class Win32_OSRecoveryConfiguration
#$OSRecovery | fl *
$Dumpfile = $OSRecovery.ExpandedDebugFilePath
$DumpFile | fl *
#>
