<#
.DESCRIPTION
  Example on using (custom) Microsoft Azure template.
.PARAMETER <Parameter Name>
  (TBD)
.EXAMPLE
  (TBD)
.INPUTS
  (TBD)
.OUTPUTS
  (TBD)
.RETURNVALUE
  (TBD)
.EXAMPLE
  (TBD)

.NOTES
  Filename  : AzureTemplate.Example.ps1
.NOTES
  2017-09-06 (NielsGrove) Script file create to prepare example.

.LINK
  TechNet Library: about_Functions_Advanced
  https://technet.microsoft.com/en-us/library/dd315326.aspx
#>

#Requires -Version 4
Set-StrictMode -Version Latest

Import-Module $PSScriptRoot\AzuteTemplates.psm1


#region SimpleStorage

Set-Location -LiteralPath 'M:\GitHub\AzureAdmin\AzureTemplates' -Verbose
[string]$ResourceGroupName = 'SimpleServer'
[string]$Location = 'West Europe'

Login-AzureRmAccount

New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

$AzureRmResourceGrp = Get-AzureRmResourceGroup -Name $ResourceGroupName
Set-AzureRmResourceGroup -Tag @{msDescription="Simple Server"} -ResourceId $ResourceGrp.ResourceId -Force

$Tags = (Get-AzureRmResourceGroup -Name $ResourceGroupName).Tags
$Tags += @{msDescription = 'Simple Server.'}  #Does Not Work
New-AzureRmTag -Name 'msDescription' -Value 'Simple Server'  #Does Not Work

New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile SimpleServer.json -storageNamePrefix simple

Remove-AzureRmResourceGroup -Name $ResourceGroupName


function Verb-Noun {
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
.NOTES
  <timestamp> <version>  <initials> <version changes and description>
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$param1
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Verb-Noun( '$param1' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
}

End {
  $mywatch.Stop()
  [string]$Message = "<function> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Verb-Noun()

#endregion SimpleStorage


###  INVOKE  ###

Clear-Host
#<function call> -Verbose -Debug

Remove-Module AzureTemplates
