<#
.DESCRIPTION
  Install Microsoft Team Foundation Server (TFS) 2018 with the PowerShell module "TfsInstall".
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

if ( (Get-Module -Name TfsInstall) -ne $null ) { Remove-Module -Name TfsInstall -ErrorAction Stop }
Import-Module $PSScriptRoot\TfsInstall.psm1


#region TFS2018

function Start-TfsInstaller {
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
  [string]$TfsServerRole
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Start-TfsInstaller( '$TfsServerRole' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  Install-Tfs -ServerRole $TfsServerRole
}

End {
  $mywatch.Stop()
  [string]$Message = "Start-TfsInstaller finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Start-TfsInstaller()

#endregion TFS2018


###  INVOKE  ###

Clear-Host
Start-TfsInstaller -TfsServerRole 'ApplicationTier' -Verbose #-Debug
Start-TfsInstaller -TfsServerRole 'Database' -Verbose #-Debug
Start-TfsInstaller -TfsServerRole 'CodeSearch' -Verbose #-Debug
Start-TfsInstaller -TfsServerRole 'Reporting' -Verbose #-Debug
