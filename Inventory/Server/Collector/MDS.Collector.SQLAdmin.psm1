# Requires -Version 4.0

<#
.SYNOPSIS
  Get installation metadata on SQL Server Master Data Services.
  Data are stored in SQLAdmin Inventory.
.DESCRIPTION
.INPUTS
  (none)
.OUTPUTS
  (none)
.NOTES
  Filename  : MDS.Collector.SQLAdmin.psm1

.NOTES
  2015-02-16 (Niels Grove-Rasmussen) Script created.
  2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.

.EXAMPLE
./Get-MsSqlAs.ps1
.LINK
Get-Help about_Comment_Based_Help  (http://technet.microsoft.com/en-us/library/hh847834.aspx)
#>

Set-StrictMode -Version Latest


#[String]$SqladminSsdb = 'DNDBA01.dn.lan'
#[String]$SqladminDb = 'dn_sqladmin'


function Register-MsSqlMd {
<#
.DESCRIPTION
.PARAMETER <parameter>
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
  ??? (Niels Grove-Rasmussen) Function created
#>
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [string]$ComputerName = '.'
)

Begin {
  "{0:s}Z  Register-MsSqlMd '$ComputerName' )" -f $([System.DateTime]::UtcNow) | Write-Verbose
}

Process {
  $CnnSqladmin = New-Object System.Data.SqlClient.SqlConnection
  $CnnSqladmin.ConnectionString = "Server=$SqladminSsdb;Integrated Security=SSPI;Database=$SqladminDb;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"

  [String]$WQL = "SELECT Name FROM Win32_Service WHERE Name LIKE 'MSSQLServerOLAPService'"
  Request-MsSqlAs -ComputerName $ComputerName |
  ForEach-Object {
    "{0:s}Z  '$ComputerName' has SSAS installed." -f $([System.DateTime]::UtcNow) | Write-Verbose
	$cnnSqladmin.Open()
	$cmdSqladmin = New-Object System.Data.SqlClient.SqlCommand '[sqladmin].[ssas-set]', $cnnSqlAdmin
	$cmdSqladmin.CommandType = [System.Data.CommandType]::StoredProcedure
	$cmdSqladmin.Parameters.Add('@computer_name', [System.Data.SqlDbType]::NVarChar, 128).Value = $ComputerName
	$cmdSqladmin.Parameters.Add('@ssas_name', [System.Data.SqlDbType]::NVarChar, 128).Value = '.'  # Only default SSAS instance right now
	try { $rc = $cmdSqladmin.ExecuteNonQuery() }
	catch { throw $_ }
	$cmdSqladmin = $null
	$cnnSqladmin.Close()
	
	if ($rc -ne -1) { "{0:s}  Update on `"$ComputerName`" failed. Return value = `"$rc`"." -f $([System.DateTime]::Now) | Write-Output }
	else { "{0:s}  `"$ComputerName`" updated with success." -f $([System.DateTime]::Now) | Write-Output }
  }
  $cnnSqladmin = $null
}

End {}
}


function Request-MsSqlMd {
<#
.DESCRIPTION
.PARAMETER <parameter>
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
  ??? (Niels Grove-Rasmussen) Function created.
#>
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [String]$ComputerName = '.'
)

Begin {
  "{0:s}Z  Request-MsSqlMd( '$ComputerName' )" -f $([System.DateTime]::UtcNow) | Write-Verbose
}

Process {
    [string]$WQL = "SELECT Name FROM Win32_Service WHERE Name LIKE 'MSSQLServerOLAPService'"
    try {
      Get-WmiObject -Query $WQL -ComputerName $ComputerName
    }
    <#catch [System.Runtime.InteropServices.COMException] {
      if ($Error[0].Exception.Message -eq 'The RPC server is unavailable. (Exception from HRESULT: 0x800706BA)') {
        "{0:s}Z  The RPC server at '$ComputerName' is unavailable. (Exception from HRESULT: 0x800706BA)" -f $([System.DateTime]::UtcNow)
      }
    }#>
    catch {
      "{0:s}Z  WMI query against `"$ComputerName`" failed:" -f $([System.DateTime]::UtcNow) | Write-Error
      $Error[0].Exception.Message | Write-Error
    }
}

End {}
}


### INVOKE ###
# ToDo : Refactor to module
Get-SqlAdminComputer |
ForEach-Object {
  Register-MsSqlMd -ComputerName $_.computer_name -Verbose
}
