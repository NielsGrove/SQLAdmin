<#
.DESCRIPTION
.PARAMETER <Parameter Name>
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

#region SqlServer

# Find local SSDB instances
function Get-Ssdb {
  [string[]]$SsdbNames
  [string[]]$SsdbNames = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances

  [PSObject[]]$Ssdb = @()
  foreach($SsdbName in $SsdbNames) {
    # Verify sysadmin rights on each SSDB instance (check on CREATE ANY DATABASE permission)
	 $sql = "SELECT TOP 1 permission_name FROM fn_my_permissions(NULL, 'SERVER') WHERE permission_name = '$permission'"
	 $da = new-object System.Data.SqlClient.SqlDataAdapter `
    ($sql, $connStr)
    $da.SelectCommand.CommandTimeout = 10
    $dt = new-object System.Data.DataTable
    $da.fill($dt) | out-null
    #return $dt.Rows.Count -gt 0

	# Get major version on each SSDB instance
	[string]$name = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$SsdbName
    [string]$edition = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$name\Setup").Edition
    [string]$version = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$name\Setup").Version
    switch -wildcard ($version) {
      "12*" {$versionname = "SQL Server 2014";}
      "11*" {$versionname = "SQL Server 2012";}
      "10.5*" {$versionname = "SQL Server 2008 R2";}
      "10.4*" {$versionname = "SQL Server 2008";}
      "10.3*" {$versionname = "SQL Server 2008";}
      "10.2*" {$versionname = "SQL Server 2008";}
      "10.1*" {$versionname = "SQL Server 2008";}
      "10.0*" {$versionname = "SQL Server 2008";}
      "9*" {$versionname = "SQL Server 2005";}
      "8*" {$versionname = "SQL Server 2000";}
      default {$versionname = $version;}
    }
  }
}

# Verify sysadmin rights on each SSDB instance
function Test-SqlSysAdmin {}

# Get major version on each SSDB instance
function Get-SqlVersion {}

#endregion SqlServer


#region SqlDiagInfo

function Get-SqlDiagInfoScript {
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
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$param1
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "[{0:s}Z  BEGIN  ]  <function name>( '$param1' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  "[{0:s}Z  PROCESS]" -f [System.DateTime]::UtcNow | Write-Verbose
}

End {
  $mywatch.Stop()
  [string]$Message = "<function name> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Get-SqlDiagInfoScript()

#endregion SqlDiagInfo


Export-ModuleMember -Function
