<#
.DESCRIPTION
  PowerShell module for collecting information about SQL Server installations.
  This file holds the core functions.
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE

.NOTES
  Filename  : Core.Collector.SQLAdmin.psm1
.NOTES
  2017-06-30  (Niels Grove-Rasmussen)  Module file created on various old scriptfiles - also as test for PowerShell project in GitHub with Visual Studio

.LINK
  Get-Help about_Comment_Based_Help
.LINK
  TechNet Library: about_Functions_Advanced
  https://technet.microsoft.com/en-us/library/dd315326.aspx
#>

#Requires -Version 4
Set-StrictMode -Version Latest


#region SQLAdmin

function Start-SqlAdmin {
<#
.DESCRIPTION
  Start SQLAdmin Collector core.
.PARAMETER <parameter>
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
2015-04-23 (NGR) Function created on global statements.
#>
[CmdletBinding()]
[OutputType([void])]
Param()

Begin {
  "{0:s}Z  Start-SqlAdmin()" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  [System.DateTime]$script:ScriptTimeStart = [System.DateTime]::UtcNow
  "Script start time = {0:s}Z." -f $script:ScriptTimeStart | Write-Debug

  "Flag indicating if this script file has been invoked. Used by SqlAdmin.Config.ps1." | Write-Verbose
  [bool]$script:SqlAdminCore = $true

  "dot-source inclusion of SQLAdmin configuration." | Write-Verbose
  . "$script:ScriptPath\SqlAdmin.Config.ps1"

  [string]$script:CnnStrSqlAdmin = "Server=$SqlAdminSsdb;Integrated Security=SSPI;Database=$SqladminDb;Application Name=SqlAdmin"
  "SQLAdmin connection string: $CnnStrSqlAdmin" | Write-Debug
  $script:CnnSqlAdmin = New-Object System.Data.SqlClient.SqlConnection $script:CnnStrSqlAdmin
}

End {}
}  # Start-SqlAdmin()


Function Get-SqlAdminComputer {
<#
.DESCRIPTION
  Get list of active computers in the SQLAdmin Inventory.
.PARAMETER <parameter>
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
#>
[CmdletBinding()]
[OutputType([void])]
Param()

Begin {
  "{0:s}Z  Get-SqlAdminComputer()" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
    [string]$strSqladmin = "Server=$SqladminSsdb;Integrated Security=SSPI;Database=$SqladminDb;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"
    $cnnSqladmin = New-Object System.Data.SqlClient.SqlConnection
    $cnnSqladmin.ConnectionString = $strSqladmin
    try { $cnnSqladmin.Open() }
    catch { throw $_ }
    $dml = 'SELECT [computer_name] FROM [sqladmin].[v_computer];'
    $ds = New-Object System.Data.DataSet
    $da = New-Object System.Data.SqlClient.SqlDataAdapter $dml, $cnnSqladmin
    [Int]$rc = $da.Fill($ds)
    $cnnSqladmin.Close()
    $cnnSqladmin = $null

    $ds.Tables[0]
}

End {}
}

#endregion SQLAdmin


#region Logging

function Start-Log {
<#
.DESCRIPTION
Start script log to log file.
.PARAMETER LogFileName
Short log file name. This function will generate full log file name with full path.
.INPUTS
(none)
.OUTPUTS
(none)
.RETURNVALUE
(none)
#>
[CmdletBinding()]
[OutputType([void])]
param(
  [Parameter(Mandatory=$true)]
  [String]$LogFileName
)
Begin {
  "{0:s}Z  Start-Log()" -f [System.DateTime]::UtcNow | Write-Verbose
  Import-Module sqlps -DisableNameChecking
}

Process {
  $SmoServer = New-Object Microsoft.SqlServer.Management.Smo.Server $SqlAdminSsdb
  $LogPath = $SmoServer.ErrorLogPath

  $script:LogTimeStart = [System.DateTime]::UtcNow
  $script:LogFileName = "$LogPath\$LogFileName.{0:yyyyddMMTHHmmss}.log" -f $script:ScriptTimeStart
  "Log File Name: $LogFileName" | Write-Debug
  "{0:s}Z  Script logging start." -f $script:LogTimeStart | Out-File -FilePath $script:LogFileName -Width 1024
}

End {}
}  # Start-Log()


function Write-Log {
<#
.DESCRIPTION
.PARAMETER <Parameter Name>
.INPUTS
.OUTPUTS
.RETURNVALUE
#>
[CmdletBinding()]
[OutputType([void])]
param(
  [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [String]$LogMessage
)
Begin {
  "{0:s}Z  Write-Log()" -f [System.DateTime]::UtcNow | Write-Verbose

  if ($script:LogFileName -eq '' -or $script:LogFileName -eq $null ) {
    "Script logging functions requires a defined LogFileName in the script file." | Write-Error
    throw "Missing LogFileName."
  }
}

Process {
  "{0:s}Z  $LogMessage" -f [System.DateTime]::UtcNow | Out-File -FilePath $script:LogFileName -Append -Width 1024
}

End {}
}  # Write-Log()


function Stop-Log {
<#
.DESCRIPTION
.PARAMETER <Parameter Name>
.INPUTS
.OUTPUTS
.RETURNVALUE
#>
[CmdletBinding()]
[OutputType([void])]
param()
Begin {
}

Process {
  $LogTimeStop = [System.DateTime]::UtcNow
  [System.TimeSpan]$ScriptDuration = $LogTimeStop - $script:ScriptTimeStart
  "{0:s}Z  Script logging stop. Script duration = $($ScriptDuration.ToString()) [hh:mm:ss.ddd]." -f $LogTimeStop >> $script:LogFileName
  ([IO.FileInfo]$script:LogFileName).IsReadOnly = $true
}

End {}
}  # Stop-Log()

#endregion Logging

###  INVOKE  ###
Start-SqlAdmin #-Verbose #-Debug

"::  End of SQLAdmin Core" | Write-Verbose

