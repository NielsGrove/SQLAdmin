<#
.DESCRIPTION
  Uninstall TFS 2018 installed local.
  TFS databases are dropped.
  SQL Server components are not removed.
.NOTES
  Get access from vmware guest in PowerShall administrator session run this to get access to file on host in shared folder:
  net use Z: '\\vmware-host\Shared Folders'
#>

#Requires -Version 5
Set-StrictMode -Version Latest

function Remove-TfsCodeSearch {
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
  Win32_Service class
  (https://msdn.microsoft.com/en-us/library/aa394418.aspx)
#>
[CmdletBinding()]
[OutputType([void])]
Param()

Begin {}

Process {
  'Stop TFS Code Search service (ElasticSearch)...' | Write-Verbose
  $CodeSearchSvc = Get-WmiObject -Class Win32_Service -Filter "Name='$((Get-Service "elastic*").Name)'"
  $Return = $CodeSearchSvc.StopService()
  if ($Return.ReturnValue -eq 0)
  { '  Service stopped.' | Write-Verbose }
  else
  { throw "Could not stop TFS Code Search service. Return value = '$($Return.ReturnValue)'. Check documentation on StopService method of the WMI Win32_Service class." }

  'Delete TFS Code Search service...' | Write-Verbose
  $Return = $CodeSearchSvc.Delete()
  if ($Return.ReturnValue -eq 16)
  { '  The service is being removed from the system.' | Write-Verbose }
  else
  { throw "Could not delete TFS Code Search service. Return value = '$($Return.ReturnValue)'. Check documentation on Delete method of the WMI Win32_Service class." }

  'Delete files for TFS Code Search...' | Write-Verbose
  Remove-Item -Path 'C:\TfsData\Search' -Recurse -Force

  'Uninstall Java manually. Remember to remove Windows environment variable JAVA_HOME.' | Write-Verbose
}

End {}
}


Remove-TfsCodeSearch -Verbose #-Debug
