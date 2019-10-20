<#
.DESCRIPTION
  Example on creating and managing a virtual server using VMware VIX through PowerShell.
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE
.LINK
  (https://stackoverflow.com/questions/7487511/calling-vix-api-from-powershell)
.LINK
  (https://blogs.vmware.com/vix/2008/12/call-vix-more-easily-from-net-plus-powershell-goodness.html)
#>

#Requires -Version 5
Set-StrictMode -Version Latest

[System.IO.DirectoryInfo]$VixFolder = 'C:\Program Files (x86)\VMware\VMware VIX\Workstation-15.0.0\64bit\'
if ($VixFolder.Exists) { 'VIX folder exists.' | Write-Debug }
else { "The Vix folder ($($VixFolder.FullName)) does not exist." | Write-Error }

[System.IO.FileInfo]$VixFile = $VixFolder.FullName + 'vix.dll'
if ($VixFile.Exists) { 'VIX file exists.' | Write-Debug }
else { "The VIX file ($(VixFile.Name)) does not exist." | Write-Error }

Add-Type -LiteralPath $VixFile.FullName -PassThru

# Error: BAD IL format
$Vix = New-Object -ComObject 'Vix.COM'
$Vix = New-Object -ComObject 'VixCOM.VixLib'

###  INVOKE  ###

Set-Variable -Name VIX_API_VERSION -Option ReadOnly -Value 1  # Change to -Option Constant when values are well-known



Clear-Host
#<function call> -Verbose -Debug