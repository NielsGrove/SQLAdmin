# Requires -Version 4.0

<#
.DESCRIPTION
  Get informatio on SQL Server Analysis Services and store in SQLAdmin Inventory.

  ToDo : Refactor from stand-alone script to module
.INPUTS
  (none)
.OUTPUTS
  (none)
.NOTES
  Filename  : SSAS.Collector.SQLAdmin.psm1

.NOTES
  2014-01-06 (Niels Grove-Rasmussen) Script created.
  2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to Github.

.EXAMPLE
.LINK
Get-Help about_Comment_Based_Help  (http://technet.microsoft.com/en-us/library/hh847834.aspx)
#>

Set-StrictMode -Version Latest


[string]$SqladminSsdb = 'DNDBA01.dn.lan'
[string]$SqladminDb = 'dn_sqladmin'


function Register-MsSqlAs {
<#
.DESCRIPTION
.PARAMETER <parameter>
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
#>
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [string]$ComputerName = '.'
)

Begin {
  "{0:s}Z  Get-MsSqlAs( '$ComputerName' )" -f $([System.DateTime]::UtcNow) | Write-Verbose
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


function Request-MsSqlAs {
<#
.DESCRIPTION
.PARAMETER <parameter>
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
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
    [String]$WQL = "SELECT Name FROM Win32_Service WHERE Name LIKE 'MSSQLServerOLAPService'"
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


Function Get-SqlAdminComputer {
<#
.DESCRIPTION
.PARAMETER <parameter>
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
#>
[CmdletBinding()]
Param()

Begin {
  "{0:s}Z  Get-SqlAdminComputer()" -f $([System.DateTime]::UtcNow) | Write-Verbose
}

Process {
	$strSqladmin = "Server=$SqladminSsdb;Integrated Security=SSPI;Database=$SqladminDb;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"
	$cnnSqladmin = New-Object System.Data.SqlClient.SqlConnection
	$cnnSqladmin.ConnectionString = $strSqladmin
	try { $cnnSqladmin.Open() }
	catch { throw $_ }
	$dml = 'SELECT [computer_name] FROM [sqladmin].[v_computer];'
	$ds = New-Object System.Data.DataSet
	$da = New-Object System.Data.SqlClient.SqlDataAdapter $dml, $cnnSqladmin
	$rc = $da.Fill($ds)
	$cnnSqladmin.Close()
	$cnnSqladmin = $null
	$ds.Tables[0]
}

End {}
}


### INVOKE ###
# ToDo : Refactor from stand-alone script to module
Get-SqlAdminComputer |
ForEach-Object {
  Register-MsSqlAs -ComputerName $_.computer_name -Verbose
}
