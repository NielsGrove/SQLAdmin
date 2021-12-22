<#
.DESCRIPTION
  Compare SQL Server instances of the same service.
#>

#Requires -Version 7
Set-StrictMode -Version Latest

#region CompareInstance

function Compare-SqlInstance {
<#
.DESCRIPTION
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$param1
)
Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "[{0:s}Z  BEGIN  ]  Compare-SqlInstance( '$param1' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  "[{0:s}Z  PROCESS]" -f [System.DateTime]::UtcNow | Write-Verbose
}

End {
  $mywatch.Stop()
  [string]$Message = "Compare-SqlInstance finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Compare-SqlInstance

#endregion CompareInstance


#region SSDB

function Compare-SsdbConfig {
<#
.DESCRIPTION
  Compare values from sp_configure.
#>
}

#endregion SSDB

#region SSAS
#endregion SSAS

#region SSIS
#endregion SSIS

#region SSRS
#endregion SSRS


#region MDS
#endregion MDS

#region DQS
#endregion DQS
