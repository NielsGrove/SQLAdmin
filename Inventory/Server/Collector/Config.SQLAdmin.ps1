# Requires -Version 4.0

<#
.DESCRIPTION
  Configuration for load of data to SQLAdmin Repository. Used in data load scripts (.ps1). Included by dot-sourcing.
.PARAMETER <Parameter Name>
  (none)
.RETURNVALUE
  (none)
.EXAMPLE

.NOTES
  Filename  : Config.SQLAdmin.ps1
.NOTES
  2012-11-30 (Niels Grove-Rasmussen) File created
  2014-08-22 (Niels Grove-Rasmussen) SCCM config added
  2015-03-06 (Niels Grove-Rasmussen) Copy to SQLAdmin in codeplex.
  2017-07-01 (Niels Grove-Rasmussen) Move to GitHub.
.REFERENCE
  (none)
#>

Set-StrictMode -Version Latest


"::  SQLAdmin Config" | Write-Verbose

# The variable ScriptPath is defined in the root script file.
# The variable SqlAdminCore is defined in the script file "SqlAdmin.Core.ps1".
if ($script:ScriptPath -eq $null -or $script:SqlAdminCore -ne $true) {
  throw 'The SQLAdmin Config script file must be called correct from the SQLAdmin Core script file.'
}


[string]$Environment = 'Sandbox'
"SQLAdmin environment: $Environment" | Write-Debug

[string]$script:SqlAdminSsdb = '(local)'
"SQLAdmin Repository database instance: $SqlAdminSsdb" | Write-Debug

[string]$script:SqlAdminDb = 'sqladmin'
"SQLAdmin Repository database: $SqlAdminDb" | Write-Debug


#region vmWare

[string]$script:VCenterSsdb = 'VCENTERSQL001.prod.lan'
"vCenter database server = '$VCenterMsSqlDb'." | Write-Debug

[string]$script:VCenterDb = 'VCDB'
"vCenter database = '$VCenterDb'." | Write-Debug

#endregion vmWare


#region SCCM

[string]$script:SccmSsdb = 'SCCMSQL001.prod.lan'
"SCCM database instance = '$SccmSsdb'." | Write-Debug

[string]$script:SccmDb = 'SMS_S01'
"SCCM database = '$SccmDb'." | Write-Debug

#endregion SCCM


#region SCOM

#endregion SCOM


#region SCSM

#endregion SCSM


"::  End Of SQLAdmin Config" | Write-Verbose