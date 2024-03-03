# Requires -version 4.0

<#
.DESCRIPTION
  Launch SqlAnchor on a local Windows workstation from a fileshare.

.PARAMETER <Parameter Name>
  (none)
.EXAMPLE
  Command line in shortcut
  powershell.exe -WindowStyle "Hidden" -File "\\fileserver001.sqladmin.lan\IT\DBA\SqlAnchor\Production\SqlAnchor.Launch.ps1" -ExecutionPolicy "Bypass"

.INPUTS
  (none)
.OUTPUTS
  (nonne)
.RETURNVALUE
  (none)

.NOTES
  Filename  : SqlAnchor.Launch.ps1
.NOTES
  2012-09-13 (Niels Grove-Rasmussen) Script created
  2014-10-24 (Niels Grove-Rasmussen) Function renamed and parameter added. Comments changed to Verbose output.
  2014-10-30 (Niels Grove-Rasmussen) File name "SqlAnchor.SSIS js" added.
  2014-10-31 (Niels Grove-Rasmussen) File name "SqlAnchor.Version.js" renamed to "SqlAnchor.MSSQL.js".
  2014-11-03 (Niels Grove-Rasmussen) Files "SqlAnchor.Main.js" and "SqlAnchor.DetailPages.js" deprecated.
  2014-11-11 (Niels Grove-Rasmussen) File name "SqlAnchor.SSAS.js" added to copy-array.
  2015-04-22 (Niels Grove-Rasmussen) Changed to new folder structure. copy-array is removed.
  2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
#>


Set-StrictMode -Version Latest


function Invoke-SqlAnchor {
<#
.DESCRIPTION
  Copy files to local drive and start SQLAnchor.
.PARAMETER Environment
  Name of environment context.
.INPUTS
  (none)
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.NOTES
  ??? (Niels Grove-Rasmussen) Function created
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage='Invoke the HTA that is SQLAnchor.')]
  [ValidateSet('Production', 'Development', IgnoreCase=$false)]
  [string]$Environment
)
  "Environment = '$Environment'." | Write-Debug
  switch -CaseSensitive ($Environment) {
	'Production' {
      [System.IO.DirectoryInfo]$SourceFolder = '\\fil01.prod.lan\It\DBA\SqlAnchor\Production'
	  [System.IO.DirectoryInfo]$TargetFolder = 'C:\SQLAdmin\SqlAnchor'
    }
    'Development' {
	  [System.IO.DirectoryInfo]$SourceFolder = '\\fil01.dn.lan\It\DBA\SqlAnchor\Development'
	  [System.IO.DirectoryInfo]$TargetFolder = 'C:\SQLAdmin\SqlAnchor\Development'
    }
  }
  if (Test-Path -path $TargetFolder)
  { Remove-Item $TargetFolder -Recurse -Force }
  'Make sure destination folder is available...' | Write-Verbose
  New-Item $TargetFolder -Type Directory -Force

  'Copy HTA files...' | Write-Verbose
  Copy-Item -Path "$SourceFolder\SqlAnchor.hta" -Destination "$TargetFolder\" -Force
  Copy-Item -Path "$SourceFolder\SqlAnchor.config.js" -Destination "$TargetFolder\" -Force
  Copy-Item -Path "$SourceFolder\Scripts\" -Destination "$TargetFolder\Scripts\" -Recurse -Force
  Copy-Item -Path "$SourceFolder\Themes\" -Destination "$TargetFolder\Themes\" -Recurse -Force

  'Start HTA...' | Write-Verbose
  & "$env:SystemRoot\System32\mshta.exe" "$TargetFolder\SqlAnchor.hta"
}


### INVOCATION ###
Clear-Host
Invoke-SqlAnchor -Environment 'Development' -Verbose #-Debug
