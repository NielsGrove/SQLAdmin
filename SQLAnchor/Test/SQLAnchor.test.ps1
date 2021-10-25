<#
.DESCRIPTION
  Test the PowerShell script module 'SQLAnchor.psm1'
#>

Import-Module -Name PSScriptAnalyzer

Invoke-ScriptAnalyzer -Path ../SQLAnchor.psm1
