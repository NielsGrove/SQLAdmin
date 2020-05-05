<#
.DESCRIPTION
  Pre-Configure computer before sysprep and role configuration.
  Copy script content to local PowerShell session and execute.

  ToDo: Re-write to execute tasks through vmrun.
#>

'Check if PowerShell session is running As Administrator...'
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] “Administrator”) -eq $true) {
    "{0:s}Z  The user is local administrator." -f [System.DateTime]::UtcNow #| Write-Verbose
}
else {
  "{0:s}Z  Installation is aborted as the user is not local administrator." -f [System.DateTime]::UtcNow
  throw "The user is not local administrator."
}

'Change drive letter on CD-ROM from D to X (xternal)...' # | Write-Verbose
Get-WmiObject -Class win32_volume -Filter 'DriveType=5' | Set-WmiInstance -Arguments @{DriveLetter='X:'}

'Configure Print Spooler service...'
Stop-Service -Name 'spooler'
Set-Service -Name 'spooler' -StartupType 'Disabled'

'Create admin-folder...'
New-Item -Path 'C:\' -Name '#sqladmin' -ItemType 'Directory'
# (From VMware host: `vmrun createDirectoryInGuest ...`)

'Change time zone to UTC...'
[string]$NewTimeZone = 'UTC'
Set-TimeZone -Id $NewTimeZone
[System.TimeZoneInfo]$TimeZone = Get-TimeZone
if ($TimeZone.Id -ceq $NewTimeZone) { 'OK - Time Zone' }
else { throw 'Wrong Time Zone - check script.' }
