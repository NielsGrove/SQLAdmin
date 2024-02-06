<#
.DESCRIPTION
  Test Delphix SQL Server Database Engine used for Target, Staging or Source.
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE

.NOTES
  Filename  : DelphixSqlTest.ps1
.NOTES
  2017-10-25 (Niels Grove-Rasmussen) The script file created on notes and mails.

.LINK
  Delphix Documentation: Overview of Requirements for SQL Server Environments
  (https://docs.delphix.com/docs/delphix-administration/sql-server-environments-and-data-sources/setting-up-and-configuring-delphix-for-sql-server/overview-of-requirements-for-sql-server-environments)
.LINK
  Delphix Documentation: Tasks for the Windows Network Administrator
  (https://docs.delphix.com/docs/delphix-administration/sql-server-environments-and-data-sources/setting-up-and-configuring-delphix-for-sql-server/tasks-for-the-windows-network-administrator)
.LINK
  Delphix Documentation: Windows Database Server Requirements
  (https://docs.delphix.com/docs/delphix-administration/sql-server-environments-and-data-sources/setting-up-and-configuring-delphix-for-sql-server/tasks-for-the-windows-system-administrator/windows-database-server-requirements)
.LINK
  Delphix Documentation: Windows Users and Permissions on Database Servers
  https://docs.delphix.com/docs/delphix-administration/sql-server-environments-and-data-sources/setting-up-and-configuring-delphix-for-sql-server/tasks-for-the-windows-system-administrator/windows-users-and-permissions-on-database-servers
.LINK
  Delphix Documentation: Database User Requirements for SQL Server
  (https://docs.delphix.com/docs/delphix-administration/sql-server-environments-and-data-sources/setting-up-and-configuring-delphix-for-sql-server/tasks-for-the-sql-server-database-administrator/database-user-requirements-for-sql-server)
#>

#Requires -Version 5
Set-StrictMode -Version Latest

#Import-Module G:\Teknik\Script\Sandbox\Module.sandbox\Module.sandbox.psm1
<#
Custom object for each test
============================
Name
Expectation
Measure
Start Time
Finish Time
----------------------------

Principles:
One test - one function
Each funk with specific reference to Delphix documentation

Ideas:
Custom Out-Html?
  Color coding where Expectation != Measure
  Status header: inputs, error count, test count
File name: DelphixSqlTest.(<host name>).<time stamp : ymd hm>.<file type>
#>

#region Delphix Target server

function Verb-Noun {
<#
.DESCRIPTION
  <Description of the function>
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  <link to external reference or documentation>
.NOTES
  <timestamp> <version>  <initials> <version changes and description>
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$param1
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Verb-Noun( '$param1' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
}

End {
  $mywatch.Stop()
  [string]$Message = "<function> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Verb-Noun()

#endregion Delphix Target server


#region Delphix Staging server

#endregion Delphix Staging server


#region Delphix Source server

#endregion Delphix Source server


#region Delphix Engine server

#endregion Delphix Engine server


#region Delphix Admin workstation

#endregion Delphix Admin workstation


#region Delphix SQL test

function Test-DelphixSql {
  <#
  .DESCRIPTION
    <Description of the function>
  .PARAMETER TargetServerName
    <parameter description>
  .PARAMETER StagingServerName
    <parameter description>
  .PARAMETER SourceServerName
    <parameter description>
  .PARAMETER DelphixServerName
    <parameter description>
  .PARAMETER AdminWorkstationName
    <parameter description>
  .PARAMETER SourceBackupFolder
    <parameter description>
  
  .NOTES
    input candidates:
    Target domain user (name & password)
    Staging domain user
    Source domain user
    Source SQL Login

  .OUTPUTS
    (none)
  .RETURNVALUE
    (none)
  .LINK
    <link to external reference or documentation>
  .NOTES
    2017-10-26 (Niels Grove--Rasmussen) Function created with initial parameters on notes
  #>
  [CmdletBinding()]
  [OutputType([void])]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
    [string]$TargetServerName,

    [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
    [string]$StagingServerName,

    [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
    [string]$SourceServerName,

    [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
    [string]$DelphixServerName,

    [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
    [string]$AdminWorkstationName,

    [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
    [System.IO.FileInfo]$SourceBackupFolder,
  )
  
  Begin {
    $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
    "{0:s}Z  ::  Verb-Noun( '$param1' )" -f [System.DateTime]::UtcNow | Write-Verbose
  }
  
  Process {
  }
  
  End {
    $mywatch.Stop()
    [string]$Message = "<function> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
    "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
  }
}  # Test-DelphixSql()
  
#endregion Delphix SQL test


###  INVOKE  ###

Clear-Host
#<function call> -Verbose -Debug