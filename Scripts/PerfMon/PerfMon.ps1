<#
.DESCRIPTION
Work with Windows Performance Counters
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE

.NOTES
2019-03-04  NGR  Script moved to GitHub (SqlAdmin)
2016-11-01  NGR  Script created for basic baseline collection set.
#>

Requires -Version 4
Set-StrictMode -Version Latest

#Import-Module {TBD}\Module.sandbox.psm1


#region CollectionSet

function Set-CollectionSet {
<#
.DESCRIPTION
  Define a collection set
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true)]
  [String]$Name
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Set-CollectionSet( '$param1' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  $DataCollectorSet = New-Object -COM Pla.DataCollectorSet
  $DataCollectorSet.DisplayName = $Name
  $DataCollectorSet.Duration = 50400
  $DataCollectorSet.SubdirectoryFormat = 1
  $DataCollectorSet.SubdirectoryFormatPattern = "yyyy\-MM"
  $DataCollectorSet.RootPath = "%systemdrive%\SQLAdmin\PerfLogs\" + $Name

  $DataCollector = $DataCollectorSet.DataCollectors.CreateDataCollector(0) 
  $DataCollector.FileName = $Name + "_"
  $DataCollector.FileNameFormat = 0x1
  $DataCollector.FileNameFormatPattern = "yyyy\-MM\-dd"
  $DataCollector.SampleInterval = 15
  $DataCollector.LogAppend = $true

  $Counters = @(
    "\PhysicalDisk\Avg. Disk Sec/Read",
    "\PhysicalDisk\Avg. Disk Sec/Write",
    "\PhysicalDisk\Avg. Disk Queue Length",
    "\Memory\Available MBytes", 
    "\Processor(_Total)\% Processor Time", 
    "\System\Processor Queue Length"
  )

  $DataCollector.PerformanceCounters = $Counters
}

End {
  $mywatch.Stop()
  [string]$Message = "<function> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Set-CollectionSet()

#endregion CollectionSet


###  INVOKE  ###

Clear-Host
Set-CollectionSet -Name 'SQLAdmin' -Verbose #-Debug
