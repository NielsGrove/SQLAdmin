<#
.DESCRIPTION
  Get and handle storage used by database and tables.
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE
.LINK
  TechNet Library: about_Functions_Advanced
  https://technet.microsoft.com/en-us/library/dd315326.aspx
#>

#Requires -Version 5
Set-StrictMode -Version Latest

Import-Module -Name SqlServer

#region SpaceUsed

function Get-SpaceUsed {
<#
.DESCRIPTION
  <Description of the function>
.PARAMETER SqlDbInstanceName
  Full name of SQL Server Database Engine instance, e.g. SANDBOX\SQL42.
.PARAMETER DatabaseName
  Name of database to get space usage info on.
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  Microsoft docs: Server Class
  (https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.management.smo.server)
.LINK
  Microsoft Docs: Database Class
  (https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.management.smo.database)
.LINK
  Microsoft Docs: Table Class
  (https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.management.smo.table)
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$SqlDbInstanceName,

  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$DatabaseName
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "[{0:s}Z  BEGIN]  Get-SpaceUsed( '$DatabaseName' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  #ToDo: Verify database instance in parameter
  $Server = New-Object Microsoft.SqlServer.Management.Smo.Server $SqlDbInstanceName
  #ToDo: Verify database in parameter
  $Database = $Server.Databases.Item($DatabaseName)

  "$DatabaseName : $($Database.Size + $Database.IndexSpaceUsage/1024) GiB" | Write-Output

  $Database.Tables |
    Where-Object {$_.isSystemObject -eq $false} | 
    Sort-Object -Property DataSpaceUsed -Descending |
    Select-Object -Property @{Name='TableName';Expression={$_.Name}},RowCount,@{Name='DataSpaceUsedMiB';Expression={$_.DataSpaceUsed/1024}}

  $Database = $null
  $Server = $null
}

End {
  $mywatch.Stop()
  [string]$Message = "Get-SpaceUsed finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "[{0:s}Z  END]  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
}
}  # Get-SpaceUsed()

#endregion <name>


###  INVOKE  ###
Clear-Host

#<# For local test. Comment out when used
$SsdbName = '(local)\SQLSERVER'
$DbName = 'ReportServer'
$FileName = 'C:\temp\SpaceUsed.txt'
#>

Get-SpaceUsed -SqlDbInstanceName $SsdbName -DatabaseName $DbName -Verbose | Out-File -LiteralPath $FileName -Append -NoClobber 
