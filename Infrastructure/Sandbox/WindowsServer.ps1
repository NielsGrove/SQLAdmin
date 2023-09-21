<#
.DESCRIPTION
  Configure Windows Server 2022 for sandbox usage in VMware Workstation Pro.
.LINK
  SQLadm blog: Sandbox Windows Server in VMware Workstation
  https://sqladm.blogspot.com/2023/09/sandbox-windows-server-in-vmware.html
#>

#Requires -Version 7
Set-StrictMode -Version Latest

function Set-NetworkAdapter {
<#
.DESCRIPTION
  Configure VM Network Adapter.
#>
[CmdletBinding()]
[OutputType([void])]
Param()

Process {
  "{0:s}Z  Configure Network Adapter..." -f [System.DateTime]::UtcNow | Write-Verbose
}
}  # Set-NetworkAdapter


###  Invoke  ###
Set-NetworkAdapter -Verbose -Debug
