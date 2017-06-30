# Requires -Version 4.0

<#
.DESCRIPTION
SQLAdmin Repository Import module
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE

.NOTES
Filename  : SqlAdmin.Import.ps1
.NOTES
2015-01-20 (NGR) Script created

.REFERENCE
Get-Help about_Comment_Based_Help
#>

Set-StrictMode -Version Latest


"::  SQLAdmin Import" | Write-Verbose

#region vmWare

function Read-VirtualComputer {
<#
.DESCRIPTION
Get computer info from VMware vCenter.
Writing data to SQLAdmin Repository is done with function(-s) in the SQLAdmin.Computer job component.
.PARAMETER <Parameter Name>
.INPUTS
(none)
.OUTPUTS
(none)
.RETURNVALUE
Custom object [PSObject] holding information on one computer.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [String]$ComputerName
)
Begin {
}

Process {
  "Computer name = '$ComputerName'." | Write-Debug

  $cnnVCenter = New-Object System.Data.SqlClient.SqlConnection
  $cnnVCenter.ConnectionString = "Server=$script:VCenterMsSqlDb;Integrated Security=SSPI;Database=$script:VCenterDb;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"

  [String]$dml = @"
SELECT
  [VMW].[VPXV_VMS].[MEM_SIZE_MB],
  [VMW].[VPXV_VMS].[NUM_VCPU],
  [VMW].[VPXV_VMS].[POWER_STATE],
  [VMW].[VPXV_VMS].[IP_ADDRESS]
FROM [VMW].[VPXV_VMS]
WHERE [DNS_NAME] = N'$ComputerName';
"@
  $cmdVCenter = New-Object System.Data.SqlClient.SqlCommand $dml, $cnnVCenter

  $SqlAdmin_Computer = New-Object -TypeName PSObject
  $SqlAdmin_Computer.PSObject.TypeNames.Insert(0,'SqlAdmin.Computer')
  Add-Member -InputObject $SqlAdmin_Computer -MemberType NoteProperty -Name Name -Value $ComputerName
	
  try { $cnnVCenter.Open() }
  catch {
    "ERROR (Read-VirtualComputer): Could not open connection to vCenter ('$VCenterSsdb')." | Write-Error
    throw $_
	}
	
    [Int]$RowCount = 0
    [System.Data.SqlClient.SqlDataReader]$rdrVCenter = $cmdVCenter.ExecuteReader()
    if ($rdrVCenter.HasRows) {
        while ($rdrVCenter.Read()) {
            if ($RowCount++ -gt 1) {
                $rdrVCenter.Close()
                $cnnVCenter.Close()
                $SqlAdmin_Computer = $null
                "{0:s}Z  More than one computer with the name '$ComputerName' found in vCenter ('$VCenterSsdb')." -f $([System.DateTime]::UtcNow) | Write-Error
            }

            [Int]$MemorySize = $rdrVCenter.GetInt32($rdrVCenter.GetOrdinal('MEM_SIZE_MB')) * 1024
            Add-Member -InputObject $SqlAdmin_Computer -MemberType NoteProperty -Name MemoryInKb -Value $MemorySize

            [Int]$CpuCount = $rdrVCenter.GetInt32($rdrVCenter.GetOrdinal('NUM_VCPU'))
            Add-Member -InputObject $SqlAdmin_Computer -MemberType NoteProperty -Name CpuCoreCount -Value $CpuCount

            [String]$PowerState = $rdrVCenter.GetString($rdrVCenter.GetOrdinal('POWER_STATE'))
            switch ($PowerState) {
                'On' { [Bool]$IsActive = $true }
                'Off' { [Bool]$IsActive = $false }
                default { [Bool]$IsActive = $null }
            }
            Add-Member -InputObject $SqlAdmin_Computer -MemberType NoteProperty -Name IsActive -Value $IsActive

            [String]$IpAddress = $rdrVCenter.GetString($rdrVCenter.GetOrdinal('IP_ADDRESS'))
            Add-Member -InputObject $SqlAdmin_Computer -MemberType NoteProperty -Name IpAddress -Value $IpAddress
        }
    }
    else {
        $rdrVCenter.Close()
        $cnnVCenter.Close()
        $SqlAdmin_Compuer = $null
        "{0:s}Z  The computer '$ComputerName' is not found in vCenter." -f $([System.DateTime]::UtcNow) | Write-Output
        return $null
    }
    $rdrVCenter.Close()
    $cnnVCenter.Close()
}

End {}
}  # Read-VirtualComputer()

#enregion vmWare


#region SCCM

<# Computer
SELECT
	Computer_System_DATA.[Name0],
	[Domain0],
	[NumberOfProcessors00],
	[SystemType00],
	--[Operating_System_DATA].[BuildNumber0],
	[Operating_System_DATA].[Caption0] AS [operatingsystem_caption],
	[CSDVersion0],[InstallDate0],
	[LastBootUpTime0],
	[Operating_System_DATA].[Version0],
	[Processor_DATA].[Name0] AS [processor_name],
	[Processor_DATA].[Version0] AS [processor_version],
	[Processor_DATA].[Revision00] AS [processor_revision],
	[AddressWidth00],
	--[DataWidth00],
	[Is64Bit00]
FROM [SMS_S01].[dbo].[Computer_System_DATA]
INNER JOIN [SMS_S01].[dbo].[Processor_DATA] ON [Computer_System_DATA].[MachineID] = [Processor_DATA].[MachineID]
INNER JOIN [SMS_S01].[dbo].[Operating_System_DATA] ON [Computer_System_DATA].[MachineID] = [Operating_System_DATA].[MachineID]
ORDER BY [Computer_System_DATA].[Name0];
#>

<# SQL Server
SELECT
	[Computer_System_DATA].[Name0] AS [computer_name],
	[Computer_System_DATA].[Domain0] AS [domain_name],
	[INSTALLED_SOFTWARE_DATA].[ProductName00] AS [product_name],
	[INSTALLED_SOFTWARE_DATA].[ProductVersion00] AS [product_version],
	[INSTALLED_SOFTWARE_DATA].[VersionMajor00] AS [version_major],
	[INSTALLED_SOFTWARE_DATA].[InstallDate00] AS [install_date]--*/
FROM [SMS_S01].[dbo].[Computer_System_DATA]
INNER JOIN [SMS_S01].[dbo].[INSTALLED_SOFTWARE_DATA] ON [Computer_System_DATA].[MachineID] = [INSTALLED_SOFTWARE_DATA].[MachineID]
WHERE [INSTALLED_SOFTWARE_DATA].[ProductName00] LIKE '%SQL Server 2%'
 AND [INSTALLED_SOFTWARE_DATA].[ProductVersion00] IS NOT NULL
 AND [Computer_System_DATA].[Name0] NOT LIKE 'PC%'
 AND [Computer_System_DATA].[Name0] NOT LIKE 'VM%'
ORDER BY [Computer_System_DATA].[Name0];
#>

#endregion SCCM


#region SCOM

#endregion SCOM


"::  End of SQLAdmin Import" | Write-Verbose
