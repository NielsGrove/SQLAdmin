<#
.DESCRIPTION
  Prepare a Hyper-V host from scratch.
  The result is a standalone Hyper-V host on Windows Server 2019 Standard Edition.

  Under construction.
#>

function Set-HyperV {
  'Test is Hyper-V is enabled...'

  'Install Hyper-V role...'
  (https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/get-started/install-the-hyper-v-role-on-windows-server)

  'Configure Hyper-V...'
}


###  INVOKE  ###
Set-HyperV

