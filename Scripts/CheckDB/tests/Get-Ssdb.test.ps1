<#
.DESCRIPTION
    Test CheckDB private function Get-Ssdb.
.OUTPUTS
.RETURNVALUE
.EXAMPLE
    ./Get-Ssdb.test.ps1
.LINK
    Get-Help about_Comment_Based_Help
#>

#Requires -Version 7
Set-StrictMode -Version Latest

Import-Module $PSScriptRoot\..\CheckDB.psm1

#region PositiveTests

Get-Ssdb -Name -Verbose -Debug
#endregion PositiveTests


#region NegativeTests

Get Ssdb -Name -Verbose -Debug
#endregion NegativeTests
