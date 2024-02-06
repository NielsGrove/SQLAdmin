<#
.DESCRIPTION
.PARAMETER <Parameter Name>
.EXAMPLE
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

#region AzureLogin

function Connect-Azure {
<#
.DESCRIPTION
  Prepare Azure usage with PoweShell module and login.
.PARAMETER (none)
  (none)
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  <link to external reference or documentation>
.NOTES
  2017-11-10 (NGR) Function created on previous routines.
#>
[CmdletBinding()]
[OutputType([void])]
Param()

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Connect-Azure()" -f [System.DateTime]::UtcNow | Write-Verbose

  Import-Module -Name AzureRM -Verbose:$false
  'Test AzureRM module import...' | Write-Verbose
  $AzureRM = Get-Module AzureRM
  if ($AzureRM)
  { 'OK - PowerShell module AzureRM is imported.' | Write-Verbose }
  else
  { throw 'PowerShell module AzureRM is NOT imported!' }
}

Process {
  'Test if already logged in Azure...' | Write-Verbose
  try
  { $AzureContext = Get-AzureRmContext -ErrorAction Continue }
  catch [System.Management.Automation.PSInvalidOperationException] {
    'Log in to Azure...' | Write-Verbose
    $AzureContext = Add-AzureRmAccount
  }
  catch
  { throw $_.Exception }
  if ($AzureContext.Account -eq $null) {
    'Log in to Azure...' | Write-Verbose
    $AzureContext = Add-AzureRmAccount
  }
  else
  { "OK - Logged in Azure as '$($AzureContext.Account)'." | Write-Verbose }
}

End {
  $mywatch.Stop()
  [string]$Message = "Connect-Azure finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Connect-Azure()

#endregion AzureLogin


#region SimpleServer

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

#endregion SimpleServer


###  INVOKE  ###

Clear-Host

Set-Location -LiteralPath 'M:\GitHub\AzureAdmin\AzureTemplates' -Verbose
[string]$ResourceGroupName = 'SimpleServer'
[string]$Location = 'West Europe'

Connect-Azure -Verbose #-Debug

New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

$AzureRmResourceGrp = Get-AzureRmResourceGroup -Name $ResourceGroupName
Set-AzureRmResourceGroup -Tag @{msDescription="Simple Server"} -ResourceId $ResourceGrp.ResourceId -Force

$Tags = (Get-AzureRmResourceGroup -Name $ResourceGroupName).Tags
$Tags += @{msDescription = 'Simple Server.'}  #Does Not Work
New-AzureRmTag -Name 'msDescription' -Value 'Simple Server'  #Does Not Work

#New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile SimpleServer.json #-storageNamePrefix simple


<# Microsoft Docs
Create a Windows virtual machine from a Resource Manager template
(https://docs.microsoft.com/en-us/azure/virtual-machines/windows/ps-template)
#>
$storageName = "st" + (Get-Random)
New-AzureRmStorageAccount -ResourceGroupName "myResourceGroup" -AccountName $storageName -Location $Location -SkuName "Standard_LRS" -Kind Storage
$accountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName myResourceGroup -Name $storageName).Value[0]
$context = New-AzureStorageContext -StorageAccountName $storageName -StorageAccountKey $accountKey 
New-AzureStorageContainer -Name "templates" -Context $context -Permission Container


$templatePath = "https://" + $storageName + ".blob.core.windows.net/templates/CreateVMTemplate.json"
$parametersPath = "https://" + $storageName + ".blob.core.windows.net/templates/Parameters.json"
New-AzureRmResourceGroupDeployment -ResourceGroupName "myResourceGroup" -Name "myDeployment" -TemplateUri $templatePath -TemplateParameterUri $parametersPath


# CleanUp
Remove-AzureRmResourceGroup -Name $ResourceGroupName
