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

Import-Module VMware.VimAutomation.Core
<#  Error
Import-Module : The specified module 'VMware.VimAutomation.Core' was not loaded because no valid module file was found in any module directory.
At line:1 char:1
+ Import-Module VMware.VimAutomation.Core
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ResourceUnavailable: (VMware.VimAutomation.Core:String) [Import-Module], FileNotFoundException
    + FullyQualifiedErrorId : Modules_ModuleNotFound,Microsoft.PowerShell.Commands.ImportModuleCommand
#>

Import-Module -Name 'C:\Program Files (x86)\VMware\VMware VIX\Workstation-14.0.0\64bit\vix.dll'
Add-Type -LiteralPath 'C:\Program Files (x86)\VMware\VMware VIX\Workstation-14.0.0\64bit\vix.dll'
<# Error
Import-Module : Filen eller assemblyen 'file:///C:\Program Files (x86)\VMware\VMware VIX\Workstation-14.0.0\64bit\vix.dll' 
eller en af dens afhængigheder kunne ikke indlæses. Modulet forventedes at indeholde et assemblymanifest.
At line:1 char:1
+ Import-Module -Name 'C:\Program Files (x86)\VMware\VMware VIX\Worksta ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Import-Module], BadImageFormatException
    + FullyQualifiedErrorId : System.BadImageFormatException,Microsoft.PowerShell.Commands.ImportModuleCommand
 
Add-Type : Filen eller assemblyen 'file:///C:\Program Files (x86)\VMware\VMware VIX\Workstation-14.0.0\64bit\vix.dll' 
eller en af dens afhængigheder kunne ikke indlæses. Modulet forventedes at indeholde et assemblymanifest.
At line:1 char:1
+ Add-Type -LiteralPath 'C:\Program Files (x86)\VMware\VMware VIX\Works ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Add-Type], BadImageFormatException
    + FullyQualifiedErrorId : System.BadImageFormatException,Microsoft.PowerShell.Commands.AddTypeCommand
#>


###  INVOKE  ###

Set-Variable -Name VIX_API_VERSION -Option ReadOnly -Value 1  # Change to -Option Constant when values are well-known

$VixLib = New-Object -ComObject VixCOM.VixLib
<#  Error
New-Object : Hentning af COM-klassefabrikken for komponenten med CLSID {00000000-0000-0000-0000-000000000000} mislykkedes pga. følgende fejl: 
80040154 Klassen er ikke registreret (Undtagelse fra HRESULT: 0x80040154 (REGDB_E_CLASSNOTREG)).
At line:1 char:11
+ $VixLib = New-Object -ComObject VixCOM.VixLib
+           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ResourceUnavailable: (:) [New-Object], COMException
    + FullyQualifiedErrorId : NoCOMClassIdentified,Microsoft.PowerShell.Commands.NewObjectCommand
#>

$Job = $VixLib.Connect(-1, 10, "https://esx-server/sdk", 0, "admin", "password", 0, $null, $null)

##$apiVersion = [VixCOM.Constants]::VIX_API_VERSION
$apiVersion = Get-Variable -Name VIX_API_VERSION -ValueOnly
$hostType = 1
[string]$hostName = ''
$hostPort = 1
[string]$userName = ''
[string]$passWord = ''
$options = 1
$propertyList = 0
$jobDoneCallback = 0

$Job = $VixLib.Connect()

Clear-Host
#<function call> -Verbose -Debug