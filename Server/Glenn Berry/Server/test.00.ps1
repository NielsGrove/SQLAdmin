<#
.DESCRIPTION
.PARAMETER <Parameter Name>
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE
.LINK
  Get-Help about_Comment_Based_Help
.LINK
  TechNet Library: about_Functions_Advanced
  https://technet.microsoft.com/en-us/library/dd315326.aspx
#>

#Requires -Version 5
Set-StrictMode -Version Latest

Import-Module $PSScriptRoot\SqlDiagInfo.psm1

Clear-Host
Get-SqlDiagInfo -Verbose #-Debug

