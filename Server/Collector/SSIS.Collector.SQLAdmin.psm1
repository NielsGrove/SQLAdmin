<#
.DESCRIPTION
  Collect data on SQL Server Integration Servivecs (SSIS) installation.
  Data are stored in SQLAdmin Inventory.

.NOTES
  2013-01-23 (Niels Grove-Rasmussen) Script created for SSDB.
  2015-03-06 (Niels Grove-Rasmussen) Copy to SQLAdmin in codeplex.
  2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
#>

# Requires -Version 4.0

Set-StrictMode -Version Latest

#dot-source inclusion of core components.
#ToDo : Refactor to module
. "$(Split-Path $MyInvocation.InvocationName)\SqlAdmin.Core.ps1"


function Import-MsSqlIsDetail {
<#
.DESCRIPTION
  Main function for installing a defined SQL Server component and associated components.
.PARAMETER ServiceAbbreviation
  SQL Server Service abbreviation (see HelpMessage).
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.NOTES
  ??? (Niels Grove-Rasmussen) Function created.
#>
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true)]
  [string]$ComputerName
)

Begin {
  $MsSqlIs = New-Object -TypeName PSObject
  $MsSqlIs.PSObject.TypeNames.Insert(0, 'SqlAdmin.MsSqlIs')
}

Process {
  Add-Member -InputObject $MsSqlIs -MemberType NoteProperty -Name ComputerName -Value $ComputerName
  "MsSqlIs.ComputerName = '$($MsSqlIs.ComputerName)'" | Write-Debug


  Get-MsSqlIsDetail -MsSqlIs $MsSqlIs
}

End {}
}


function Get-MsSqlIsDetail {
<#
.DESCRIPTION
  Main function for installing a defined SQL Server component and associated components.
.PARAMETER MsSqlIs
  Custom object holding SSIS metadata.
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.NOTES
  ??? (Niels Grove-Rasmussen) Function created.
#>
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)]
  [PSObject]$MsSqlIs
)

Begin {
  "{0:s}Z  Get-MsSqlIsDetail() : Get SSIS installation data." -f $([System.DateTime]::UtcNow) | Write-Verbose
}

Process {
  $MsDts = Get-Service -Name 'MsDtsServer120' -ComputerName $MsSqlIs.ComputerName
  $MsDts | fl *
}

End {}
}

function Request-MsSqlIs {
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
  [string]$ComputerName = '.'
)

Begin {
  "{0:s}Z  Request-MsSqlAs( '$ComputerName' )" -f $([System.DateTime]::UtcNow) | Write-Verbose
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


function Register-MsSqlIs {
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
  [string]$ComputerName = '.'
)

Begin {
  "{0:s}Z  Register-MsSqlIs( '$ComputerName' )" -f $([System.DateTime]::UtcNow) | Write-Verbose
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
