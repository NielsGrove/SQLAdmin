<#
.DESCRIPTION
  Build SQL Server Availbility Group sandbox using Hyper-V.
  The sandbox is build in a isolated network.

  Still under construction...
#>

function Build-WindowsServer {
    'Build Windows Server...'
  }
  
  function Build-Windows10 {
    'Build Windows 10 workstation...'
  }
  
  function Build-DC {
    'Build Active Directory Domain Controller...'
  
    Build-WindowsServer
  
    'Initialize server...'
    'Harden DC server'
    'Initialize Domain Controller...'
    'Verify DC server'
  }
  
  function Build-PrivilegedWorkstation {
    Build-Windows10
  
    'Initialize workstation'
    'Harden workstation'
    'Add SqlServer PowerShell module'
    'Verify Privileged Workstation'
  }
  
  function Build-SQL0 {
    Build-WindowsServer
    'Harden SQL Server server'
    'Add SqlServer PowerShell module'
  }
  
  function Build-SQLSandbox {
    Initialize-VMrun
  
    'Build virtual network...'
    Build-DC
    #Build PKI?
    Build-PrivilegedWorkstation
    Build-SQL0
  }
  