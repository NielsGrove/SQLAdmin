# Requires -Version 4.0

<#
.DESCRIPTION
  SQLAdmin Inventory collection of computer information module.
.PARAMETER <Parameter Name>
  (none)
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE

.NOTES
  Filename  : Computer.Collector.SQLAdmin.ps1
.NOTES
  2013-03-20 (Niels Grove-Rasmussen) Script created
  2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex.

.REFERENCE
#>

Set-StrictMode -Version Latest


'::  SQLAdmin Computer' | Write-Verbose

function Get-ComputerInfo {
<#
.DESCRIPTION
.PARAMETER <Parameter Name>
.INPUTS
.OUTPUTS
.RETURNVALUE
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory=$true)]
  [string]$ComputerName
)
Begin {}

Process {
	Write-Debug "Import-ComputerDetail(`"$ComputerName`")"
	
	# Get IP4 address - and check if host is available
	try {
		$_ip4 = [System.Net.Dns]::GetHostAddresses($ComputerName) | Select-Object -ExpandProperty IPAddressToString
	}
	catch [System.Management.Automation.MethodInvocationException] {
		"{0:s}  Host `"$ComputerName`" is unknown." -f $([System.DateTime]::Now) | Write-Output
		return
	}

	$objComputer = New-Object System.Object
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name Name -Value $ComputerName
	
	[bool]$Local:hasWmiAccess = $true
	
	$WQL = "SELECT Manufacturer,Model,TotalPhysicalMemory,NumberOfProcessors,SystemType FROM Win32_ComputerSystem"
	try {
		$_wmi = Get-WmiObject -Query $WQL -ComputerName $ComputerName -ErrorAction SilentlyContinue
	}
	catch [System.UnauthorizedAccessException] {
		"{0:s}  WMI access denied on computer `"$ComputerName`"." -f $([System.DateTime]::Now) | Write-Output
		$hasWmiAccess = $false
	}
	catch {
		"{0:s}  WMI error on computer `"$ComputerName`"." -f $([System.DateTime]::Now) | Write-Output
		$hasWmiAccess = $false
	}
	# The error "The RPC server is unavailable. (Exception from HRESULT: 0x800706BA)" is not caught but still generates an error
	# This is a known issue on remote sessions with PowerShell v2
	if ($Error[0].Exception -match "HRESULT: 0x800706BA") {
		"{0:s}  WMI COM (RPC) not available on the computer `"$ComputerName`"." -f $([System.DateTime]::Now) | Write-Output
		$hasWmiAccess = $false
	}
	
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name Manufacturer -Value $(if ($hasWmiAccess) {$_wmi.Manufacturer} else {$null})
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name Model -Value $(if ($hasWmiAccess) {$_wmi.Model} else {$null})
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name MemoryInKb -Value $(if($hasWmiAccess) {($_wmi.TotalPhysicalMemory / 1KB)} else {$null})
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name CpuCoreCount -Value $(if ($hasWmiAccess) {$_wmi.NumberOfProcessors} else {$null})
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name SystemType -Value $(if ($hasWmiAccess) {$_wmi.SystemType} else {$null})
	
	if ($hasWmiAccess) {
		$WQL = "SELECT Name,SMBIOSBIOSVersion,SMBIOSMajorVersion,SMBIOSMinorVersion FROM Win32_BIOS"
		$_wmi = Get-WmiObject -Query $WQL -ComputerName $ComputerName
	}
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name BiosName -Value $(if ($hasWmiAccess) {$_wmi.Name} else {$null})
	if ($hasWmiAccess) {
		$_BiosVersion = "$($_wmi.SMBIOSBIOSVersion);(Major)$($_wmi.SMBIOSMajorVersion);(Minor)$($_wmi.SMBIOSMinorVersion)"
	}
	else {
		$_BiosVersion = $null
	}
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name BiosVersion -Value $_BiosVersion
	
	if ($hasWmiAccess) {
		$WQL = "SELECT Version,Caption,SerialNumber,InstallDate FROM Win32_OperatingSystem"
		$_wmi = Get-WmiObject -Query $WQL -ComputerName $ComputerName
	}
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name OsVersion -Value $(if ($hasWmiAccess) {$_wmi.Version} else {$null})
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name OsEdition -Value $(if ($hasWmiAccess) {$_wmi.Caption} else {$null})
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name OsSerialNumber -Value $(if ($hasWmiAccess) {$_wmi.SerialNumber} else {$null})
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name OsInstallTime -Value $(if ($hasWmiAccess) {(([WMI]'').ConvertToDateTime($_wmi.InstallDate))} else {$null})
	
	Add-Member -InputObject $objComputer -MemberType NoteProperty -Name IP4Address -Value $_ip4

	$objComputer
}

End {}
}  # Get-ComputerInfo()


function Write-SqlAdminComputer {
<#
.DESCRIPTION
.PARAMETER <Parameter Name>
.INPUTS
.OUTPUTS
.RETURNVALUE
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [String]$ComputerName
)
Begin {
}

Process {
$cnnSqlAdmin = New-Object System.Data.SqlClient.SqlConnection
$cnnSqlAdmin.ConnectionString = "Server=$script:SqlAdminSsdb;Integrated Security=SSPI;Database=$script:SqlAdminDb;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"
$cnnSqlAdmin.Open()
$cmdSqlAdmin = New-Object System.Data.SqlClient.SqlCommand '[sqladmin].[computer-set]', $cnnSqlAdmin
$cmdSqlAdmin.CommandType = [System.Data.CommandType]::StoredProcedure
$cmdSqlAdmin.Parameters.Add('@computer_name', [System.Data.SqlDbType]::NVarChar, 128).Value = $SqlAdmin_Computer.Name
$cmdSqlAdmin.Parameters.Add('@computer_ip4', [System.Data.SqlDbType]::Char, 15).Value = $SqlAdmin_Computer.IpAddress
$cmdSqlAdmin.Parameters.Add('@computer_memory_in_kb', [System.Data.SqlDbType]::BigInt).Value = $SqlAdmin_Computer.MemoryInKb
$cmdSqlAdmin.Parameters.Add('@computer_cpu_core_count', [System.Data.SqlDbType]::Int).Value = $SqlAdmin_Computer.CpuCoreCount
$cmdSqlAdmin.Parameters.Add('@computer_is_virtual', [System.Data.SqlDbType]::Bit).Value = 1
$cmdSqlAdmin.Parameters.Add('@computer_is_active', [System.Data.SqlDbType]::Bit).Value = $SqlAdmin_Computer.IsActive
$cmdSqlAdmin.Parameters.Add('@computer_description', [System.Data.SqlDbType]::NVarChar, 256).Value = $null  # Is is not decided where a computer description is maintained.
try { $rc = $cmdSqlAdmin.ExecuteNonQuery() }
catch { throw $_ }
    
$cmdSqlAdmin = $null
$cnnSqlAdmin.Close()
$cnnSqlAdmin = $null

if ($rc -ne -1) { "{0:s}Z  Update on '$ComputerName' failed. Return value = `"$rc`"." -f $([System.DateTime]::UtcNow) | Write-Output }
else { "{0:s}Z  '$ComputerName' updated with success." -f $([System.DateTime]::UtcNow) | Write-Output }

}

End {}
}  # Write-SqlAdminComputer


function Read-SqlAdminComputer {
<#
.DESCRIPTION
  Read all computers fra SQLAdmin Inventory.
.PARAMETER <Parameter Name>
.INPUTS
.OUTPUTS
.RETURNVALUE
  Array [DataSet] of computers registered in SQLAdmin Repository
#>
[CmdletBinding()]
param()

Begin {
    'Get-Computer()' | Write-Verbose
}

Process {
	$strSqladmin = "Server=$script:SqlAdminSsdb;Integrated Security=SSPI;Database=$script:SqlAdminDb;Application Name=SqlAdmin;Connection Timeout=5"
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
}  # Read-SqlAdminComputer()

'::  End of SQLAdmin Computer' | Write-Verbose
