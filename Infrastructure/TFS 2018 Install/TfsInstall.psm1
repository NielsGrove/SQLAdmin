<#
.DESCRIPTION
  PowerShell module for installing Microsoft Team Foundation Server (TFS).
  The module is written for PowerShell Core 6.

  (See more in README.md)
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE

.LINK
  Get-Help about_Comment_Based_Help
#>

#Requires -Version 6
Set-StrictMode -Version Latest

#region <name>

function Install-Tfs {
<#
.DESCRIPTION
  <Description of the function>
.PARAMETER ServerRole
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  <link to external reference or documentation>
.NOTES
  <timestamp> <version>  <initials> <version changes and description>
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [ValidateSet('ApplicationTier', 'Database', 'CodeSearch', 'Reporting', IgnoreCase=$false)]  # Later also 'Reports' and 'Analysis'. Maybe also 'ReportsDatabase'.
  [string]$ServerRole
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Install-Tfs( '$ServerRole' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
}

End {
  $mywatch.Stop()
  [string]$Message = "Install-Tfs finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
}
}  # Install-Tfs()

function Get-TfsServerInfo {
<#
.DESCRIPTION
  Main function to get info on server where TFS will be installed.
  Most collections of server info are plased in sub-functions where this function combines the info.
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
  "{0:s}Z  ::  <function name>( '$param1' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
}

End {
  $mywatch.Stop()
  [string]$Message = "<function name> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Verb-Noun()

#endregion <name>


###  INVOKE  ###

Clear-Host
#<function call> -Verbose -Debug