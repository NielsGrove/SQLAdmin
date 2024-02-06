<#
.DESCRIPTION
  Build virtual machine in Microsoft Azure with PowerShell.
.PARAMETER <Parameter Name>
  (none)
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE

.NOTES
  Filename  : VirtualMachine.ps1
.NOTES
  2017-07-31  (Niels Grove-Rasmussen) File created to investigate project file structure.
  2017-09-08  (NieGro) Script moved to AzureAdmin.

.LINK
  TechNet Library: about_Functions_Advanced
  https://technet.microsoft.com/en-us/library/dd315326.aspx
#>

#Requires -Version 5
Set-StrictMode -Version Latest

#Import-Module E:\GitHub\MSSqlRecoveryTester\SqlRecoveryTester\SqlDbRecoveryTester\SqlDbRecovery.psm1


#region infrastructure

function New-AzureVm {
<#
.DESCRIPTION
  Sandbox for basic virtual SQL Server Database Engine server in Azure
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  Microsoft Docs: Create and Manage Windows VMs with the Azure PowerShell module
  https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm
.NOTES
  2017-07-31  (Niels Grove-Rasmussen) Function created to implement sandbox inspired from Microsoft tutorial.
  2017-08-01  (Niels Grove-Rasmussen) Function can create one Azure vm wo/SSDB. Can begin parameterisation.
  2017-08-02  (Niels Grove-Rasmussen) Function renamed to New-AzureVm. SSDB or other application installation will be in seperate functions.
  2017-08-03  (Niels Grove-Rasmussen) Dynamic resource group name for scalability. Existince of RG test added.
  2017-08-09  (Niels Grove-Rasmussen) Stop and Deallocate virtual machine added.
  2017-09-05  (NieGro) Get credentials for vm admin moved to start of function.
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  #[Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  #[string]$param1
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  New-AzureVm()" -f [System.DateTime]::UtcNow | Write-Verbose

  Import-Module -Name AzureRM

  'Test AzureRM module import...' | Write-Verbose
  $AzureRM = Get-Module AzureRM
  if ($AzureRM)
  { 'OK - PowerShell module AzureRM is imported.' | Write-Verbose }
  else
  { throw 'PowerShell module AzureRM is NOT imported!' }

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

Process {
  'Get credentials for admin on vm...' | Write-Verbose
  <# ToDo : Test and loop password requirements
  New-AzureRmVM : The supplied password must be between 8-123 characters long and must satisfy at least 3 of password complexity requirements from the following: 
  1) Contains an uppercase character
  2) Contains a lowercase character
  3) Contains a numeric digit
  4) Contains a special character.
  #>
  try { $cred = Get-Credential }
  catch {
    throw $_.Exception
  }

  'Create Azure Resource Group identifier...' | Write-Verbose
  # 48..59  : cifres 0 (zero) to 9 in ASCII
  # 65..90  : Uppercase letters in ASCII
  # 97..122 : Lowercase letters in ASCII
  [string]$RgId = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 11 | ForEach-Object {[char]$_})
  "Azure Resource Group ID = '$RgId'." | Write-Verbose

  'Setting variables with common values...' | Write-Verbose
  [psobject]$VmParams = New-Object -TypeName PSObject -Property (@{
    ResourceGroupName = 'TesterRG_' + $RgId;
    LocationName = 'WestEurope';
    SubnetName = 'TesterSubnet';
    VnetName = 'TesterVnet';
    PublicIpAddressName= 'TesterPublicIp';
    NicName = 'TesterNic';
    NsgRuleName = 'TesterNsgRule';
    NsgName = 'TesterNsg';
    OsDiskName = 'TesterOsDisk';
    Name = 'TesterVM'
  })
  $VmParams.PSObject.TypeNames.Insert(0, 'Vm.Azure')

  'Test if Azure resource group exists...' | Write-Verbose
  Get-AzureRmResourceGroup -Name $VmParams.ResourceGroupName -ErrorVariable NotPresent -ErrorAction SilentlyContinue
  if ($NotPresent)
  { "OK - Azure resource group '$($VmParams.ResourceGroupName)' does not exist." | Write-Verbose }
  else
  { throw "The Azure resource group '$($VmParams.ResourceGroupName)' does already exist." }
  "{0:s}Z  Create Azure resource group '$($VmParams.ResourceGroupName)'..." -f [System.DateTime]::UtcNow | Write-Verbose
  $RgTags = @{ MS_Description = 'Really good prose description.'; SystemId = '42' }
  $AzureResourceGroup = New-AzureRmResourceGroup -Name $VmParams.ResourceGroupName -Location $VmParams.LocationName -Tag $RgTags
  if ($AzureResourceGroup.ProvisioningState -ceq 'Succeeded')
  { "OK - Azure resource group provisioning state : '$($AzureResourceGroup.ProvisioningState)'." | Write-Verbose }
  else
  { throw "Azure resource group provisioning state : '$($AzureResourceGroup.ProvisioningState)'. 'Succeeded' was expected." }

  'Create Azure subnet...' | Write-Verbose
  $SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig `
    -Name $VmParams.SubnetName `
    -AddressPrefix 192.168.1.0/24
  'Create Azure virtual network...' | Write-Verbose
  $VirtualNetwork = New-AzureRmVirtualNetwork `
    -ResourceGroupName $VmParams.ResourceGroupName `
    -Location $VmParams.LocationName `
    -Name $VmParams.VnetName `
    -AddressPrefix 192.168.0.0/16 `
    -Subnet $SubnetConfig
  'Create Azure public IP address...' | Write-Verbose
  $PublicIpAddress = New-AzureRmPublicIpAddress `
    -ResourceGroupName $VmParams.ResourceGroupName `
    -Location $VmParams.LocationName `
    -AllocationMethod Static `
    -Name $VmParams.PublicIpAddressName
  'Create Azure network interface card (NIC)...' | Write-Verbose
  $NetworkInterface = New-AzureRmNetworkInterface `
    -ResourceGroupName $VmParams.ResourceGroupName `
    -Location $VmParams.LocationName `
    -Name $VmParams.NicName `
    -SubnetId $VirtualNetwork.Subnets[0].Id `
    -PublicIpAddressId $PublicIpAddress.Id

  'Create Azure Network Security Group (NSG):' | Write-Verbose
  'Create Azure security rule...' | Write-Verbose
  $NetworkSecurityRuleConfig = New-AzureRmNetworkSecurityRuleConfig `
    -Name $VmParams.NsgRuleName `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 1000 `
    -SourceAddressPrefix * `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 3389 `
    -Access Allow
  'Create Azure Network Security Group...' | Write-Verbose
  $NetworkSecurityGroup = New-AzureRmNetworkSecurityGroup `
    -ResourceGroupName $VmParams.ResourceGroupName `
    -Location $VmParams.LocationName `
    -Name $VmParams.NsgName `
    -SecurityRules $NetworkSecurityRuleConfig
  'Add NSG to subnet...' | Write-Verbose
  $SubnetConfig = Set-AzureRmVirtualNetworkSubnetConfig `
    -Name $VmParams.SubnetName `
    -VirtualNetwork $VirtualNetwork `
    -NetworkSecurityGroup $NetworkSecurityGroup `
    -AddressPrefix 192.168.1.0/24
  if ($SubnetConfig.ProvisioningState -ceq 'Succeeded')
  { "'OK - Azure subnet provisioning state : '$($SubnetConfig.ProvisioningState)'." | Write-Verbose }
  else
  { throw "Azure subnet provisioning state : '$($SubnetConfig.ProvisioningState)'. 'Succeeded' was expected." }
  'Update Azure virtual network...' | Write-Verbose
  $AzureVNetResult = Set-AzureRmVirtualNetwork -VirtualNetwork $VirtualNetwork
  if ($AzureVNetResult.ProvisioningState -ceq 'Succeeded')
  { "OK - Azure vnet provisioning state : '$($AzureVNetResult.ProvisioningState)'." | Write-Verbose }
  else
  { throw "Azure vnet provisioning state : '$($AzureVNetResult.ProvisioningState)'. 'Succeeded' was expected." }
  '/NSG created.' | Write-Verbose

  'Create Azure virtual machine:' | Write-Verbose
  $vmStopWatch = [System.Diagnostics.Stopwatch]::StartNew()
  'Create initial configuration...' | Write-Verbose
  $VmConfig = New-AzureRmVMConfig `
    -VMName $VmParams.Name `
    -VMSize Standard_DS2
  'Add OS information...' | Write-Verbose
  $VmConfig = Set-AzureRmVMOperatingSystem `
    -VM $VmConfig `
    -Windows `
    -ComputerName $VmParams.Name `
    -Credential $cred `
    -ProvisionVMAgent -EnableAutoUpdate
  'Add image information...' | Write-Verbose
  $VmConfig = Set-AzureRmVMSourceImage `
    -VM $VmConfig `
    -PublisherName MicrosoftWindowsServer `
    -Offer WindowsServer `
    -Skus 2016-Datacenter `
    -Version latest
  'Add OS disk settings...' | Write-Verbose
  $VmConfig = Set-AzureRmVMOSDisk `
    -VM $VmConfig `
    -Name $VmParams.OsDiskName `
    -DiskSizeInGB 128 `
    -CreateOption FromImage `
    -Caching ReadWrite
  'Add NIC...' | Write-Verbose
  $VmConfig = Add-AzureRmVMNetworkInterface -VM $VmConfig -Id $NetworkInterface.Id
  "{0:s}Z  Create virtual machine..." -f [System.DateTime]::UtcNow | Write-Verbose
  $AzureVm = New-AzureRmVM -ResourceGroupName $VmParams.ResourceGroupName -Location $VmParams.LocationName -VM $VmConfig
  if ($AzureVm.StatusCode -ceq 'OK')
  { "OK - Azure vm status code : '$($AzureVm.StatusCode)'." | Write-Verbose }
  else
  { throw "Azure vm status code: '$($AzureVm.StatusCode)'. 'OK' was expected." }
  $vmStopWatch.Stop
  "{0:s}Z OK - virtual machine created. Duration = $($vmStopWatch.Elapsed.ToString()). [hh:mm:ss.ddd]" -f [System.DateTime]::UtcNow | Write-Verbose

  'Add MS_Description to virtual machine...'
  $VmTags = @{ Name = 'Description'; Value = 'Good prose description on VM.' }
  $VmTags = @{ Name='lbl'; Value='qwerty' }
  Set-AzureRmResource -ResourceGroupName $VmParams.ResourceGroupName -ResourceName $VmParams.Name -ResourceType "Microsoft.Compute/VirtualMachines" -Tag $VmTags -Force
<#  ERROR
  Set-AzureRmResource : The pipeline has been stopped.
At line:3 char:3
+   Set-AzureRmResource -ResourceGroupName $VmParams.ResourceGroupName  ...
+   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : CloseError: (:) [Set-AzureRmResource], PipelineStoppedException
    + FullyQualifiedErrorId : Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implementation.SetAzureResourceCmdlet
 
Set-AzureRmResource : Der opstod en fejl under afsendelse af anmodningen.
At line:3 char:3
+   Set-AzureRmResource -ResourceGroupName $VmParams.ResourceGroupName  ...
+   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : CloseError: (:) [Set-AzureRmResource], HttpRequestException
    + FullyQualifiedErrorId : Der opstod en fejl under afsendelse af anmodningen.,Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implementation.SetAzureResourceCmdlet
#>


  "{0:s}Z Stop virtual machine..." -f [System.DateTime]::UtcNow | Write-Verbose
  $StopVmResult = Stop-AzureRmVM -ResourceGroupName $VmParams.ResourceGroupName -Name $VmParams.Name -Force -StayProvisioned
  if ($StopVmResult.Status -ceq 'Succeeded')
  { "OK - Azure virtual machine stop status : '$($StopVmResult.Status)'." | Write-Verbose }
  else
  { throw "Azure virtual machine stop status : '$($StopVmResult.Status)'. 'Succeeded' was expected." }
  "{0:s}Z  Deallocate virtual machine..." -f [System.DateTime]::UtcNow | Write-Verbose
  $StopVmResult = Stop-AzureRmVM -ResourceGroupName $VmParams.ResourceGroupName -Name $VmParams.Name -Force
  if ($StopVmResult.Status -ceq 'Succeeded')
  { "OK - Azure virtual machine deallocate status : '$($StopVmResult.Status)'." | Write-Verbose }
  else
  { throw "Azure virtual machine deallocate status : '$($StopVmResult.Status)'. 'Succeeded' was expected." }
}

End {
  $mywatch.Stop()
  [string]$Message = "New-AzureVm finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # New-AzureVm()

#region Test

function Test-AzureVmStart {
<#
.DESCRIPTION
  Test Azure virtual machine allocation and start
.PARAMETER ResourceGroupName
  Name of Azure resource group where the virtual machine is created
.PARAMETER VirtualMachineName
  Name of the virtual machine to test.
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  <link to external reference or documentation>
.NOTES
  2017-08-10  (Niels Grove-Rasmussen) Function created to test Allocate - Start - Stop - Deallocate of a Azure virtual machine and get some number to compare
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$false,HelpMessage='Name of Azure Resource Group where the virtual machine is created.')]
  [string]$ResourceGroupName,

  [Parameter(Mandatory=$true, ValueFromPipeLine=$false,HelpMessage='Name of the Azure Virtual Machine.')]
  [string]$VirtualMachineName
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Test-AzureVmStart( '$ResourceGroupName', 'VirtualMachineName' )" -f [System.DateTime]::UtcNow | Write-Verbose

  $CompleteMeasure = New-Object psobject
}

Process {
  "Test if resource group exists..." | Write-Verbose  # implement as parameter rule
  "  (TBD)" | Write-Verbose

  "Test if virtual machine exists..." | Write-Verbose  # implement as parameter rule
  $AzureRmVms = Get-AzureRmVM -ResourceGroupName $ResourceGroupName
  foreach ($Vm in $AzureRmVms) {
    if ($Vm.Name -ceq $VirtualMachineName)
    { "  OK - The virtual machine '$VirtualMachineName' does exist." | Write-Verbose }
    else
    { throw "The virtual machine '$VirtualMachineName' does not exist in the resource group '$ResourceGroupName'." }
  }

  "{0:s}Z  Test if virtual machine '$VirtualMachineName' is stopped and deallocated..." -f [System.DateTime]::UtcNow | Write-Verbose
  $AzureRmVmDetail = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VirtualMachineName -Status
  foreach ($VmStatus in $AzureRmVmDetail.Statuses) {
    #$VmStatus.Code | Write-Debug
    if ($VmStatus.Code -cmatch 'PowerState/(?<allocation>.*)') {
      if ($Matches['allocation'] -ceq 'deallocated')
      { "  OK - PowerState : $($Matches['allocation'])" | Write-Verbose }
      else
      { throw "The virtual machine '$VirtualachineName' is NOT stopped and deallocated. PowerState : $($Matches['allocation']). 'deallocated' expected." }
    }
  }

  "{0:s}Z  Allocate virtual machine '$VirtualMachineName'..." -f [System.DateTime]::UtcNow | Write-Verbose
  "SORRY - it is not possible to allocate and not start a virtual machine in Azure." | Write-Warning

  "{0:s}Z  Start virtual machine '$VirtualMachineName'..." -f [System.DateTime]::UtcNow | Write-Verbose
  $StartVmStopWatch = [System.Diagnostics.Stopwatch]::StartNew()
  $Result = Start-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VirtualMachineName
  if ($Result.Status -ceq 'Succeeded') {
    $StartVMStopWatch.Stop()
    "  OK - Azure virtual machine allocate status : '$($Result.Status)'." | Write-Verbose
  }
  else
  { throw "Azure virtual machine allocate status : '$($Result.Status)'. 'Succeeded' was expected." }

  "{0:s}Z  Stop virtual machine '$VirtualMachineName'..." -f [System.DateTime]::UtcNow | Write-Verbose
  $StopVmStopWatch = [System.Diagnostics.Stopwatch]::StartNew()
  $Result = Stop-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VirtualMachineName -Force -StayProvisioned
  if ($Result.Status -ceq 'Succeeded') {
    $StopVmStopWatch.Stop()
    "  OK - Azure virtual machine stop status : '$($Result.Status)'." | Write-Verbose
  }
  else
  { throw "Azure virtual machine stop status : '$($Result.Status)'. 'Succeeded' was expected." }

  "{0:s}Z  Deallocate virtual machine '$VirtualMachineName'..." -f [System.DateTime]::UtcNow | Write-Verbose
  $DeallocateVmStopWatch = [System.Diagnostics.Stopwatch]::StartNew()
  $Result = Stop-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VirtualMachineName -Force
  if ($Result.Status -ceq 'Succeeded') {
    $DeallocateVmStopWatch.Stop()
    "  OK - Azure virtual machine deallocate status : '$($Result.Status)'." | Write-Verbose
  }
  else
  { throw "Azure virtual machine deallocate status : '$($Result.Status)'. 'Succeeded' was expected." }

  $CompleteMeasure | Add-Member -NotePropertyMembers @{
    'StartVm' = $StartVmStopWatch.Elapsed;
    'StopVm' = $StopVmStopWatch.Elapsed;
    'DeallocateVm' = $DeallocateVmStopWatch.Elapsed
  }
}

End {
  $mywatch.Stop()
  [string]$Message = "Test-AzureVmStart finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Test-AzureVmStart

#endregion Test

#endregion infrastructure


###  INVOKE  ###

Clear-Host

#(0..9) |  # DOES NOT WORK
New-AzureVm -Verbose #-Debug


#Test-AzureVmStart -ResourceGroupName 'TesterRG_0RlkSHPsNO5' -VirtualMachineName 'TesterVM' -Verbose

#Remove-AzureRmResourceGroup -Name 'TesterRG_7WpKGqg4YMb' -Verbose #-Force

# Log out of Azure - DOES NOT WORK
#Login-AzureRmAccount -ErrorAction Stop
