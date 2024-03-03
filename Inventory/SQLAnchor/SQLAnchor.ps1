<#
.DESCRIPTION
  SQLAnchor main script file.
#>

#Requires -Version 7
Set-StrictMode -Version Latest

Import-Module -Name $PSScriptRoot\SQLAnchor.psm1

function Invoke-SQLAnchor {
<#
.DESCRIPTION
  Start SQLAnchor application.
#>
[CmdletBinding()]
[OutputType([void])]
Param()

Begin {
  "[{0:s}Z  BEGIN  ]  Invoke-SQLAnchor started." -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {}

End {}
}


###  Invoke  ###
Invoke-SQLAnchor -Verbose -Debug
