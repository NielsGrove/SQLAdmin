<#
.DESCRIPTION
  Create and configure virtual server on vmware (workstation) with PowerShell Module "Server.VIX.psm1".
.NOTES
  Filename : Server.VIX.ps1
.NOTES
  2017-07-17 (Niels Grove-Rasmussen) Script file created
#>

#Requires -Version 5
Set-StrictMode -Version Latest


#region VMware VIX API

function Start-VMwareVixApi {
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
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  #[Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  #[string]$param1
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "[{0:s}Z  BEGIN  ]  <function name>( 'param1' )" -f [System.DateTime]::UtcNow | Write-Verbose

  #$VMwareInstallDir = 'C:\Program Files (x86)\VMware\VMware Workstation'
}

Process {
  "[{0:s}Z  PROCESS]" -f [System.DateTime]::UtcNow | Write-Verbose
}

End {
  $mywatch.Stop()
  [string]$Message = "<function name> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Start-VMwareVixApi()

#endregion VMware VIX API


#region Virtual Machine

function New-VirtualMachine {
<#
.DESCRIPTION
  Create new virtual machine on local VMware Workstation Pro.
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  Microsoft Docs: Tlbimp.exe (Type Library Importer)
  (https://docs.microsoft.com/en-us/dotnet/framework/tools/tlbimp-exe-type-library-importer)
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='Short name of new virtual machine.')]
  [string]$Name
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "[{0:s}Z  BEGIN  ]  New-VirtualMachine( '$Name' )" -f [System.DateTime]::UtcNow | Write-Verbose

  <#
    You need to generate an interop for the VixCOM library with TlbImp.exe and add it to the PowerShell session.
    Then the library constants will be accessible.
    https://social.technet.microsoft.com/Forums/scriptcenter/en-US/35635da2-17ca-4a26-9dce-435fb3f9c194/powershell-access-to-com-constants-like-reference-object-in-wsf-file
  #>
  $TlblmpExe = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.7.2 Tools\TlbImp.exe'
  $VixComDll = '(TBD - VMware Workstation 15)'
  $VixComInterop = 'C:\VixCOM\VMWareTasks-1.7\Bin\Interop.VixCOM.dll'

  & $TlblmpExe $VixComDll /namespace:VixCOM /out:$VixComInterop

  Add-Type -Path $VixComInterop

  $VixLib = New-Object -ComObject VixCOM.VixLib
  $VixLib | gm
  
}

Process {
  "[{0:s}Z  PROCESS]" -f [System.DateTime]::UtcNow | Write-Verbose

  #$VixLib = New-Object -ComObject VixCOM.VixLib

}

End {
  $mywatch.Stop()
  [string]$Message = "New-VirtualMachine finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # New-VirtualMachine()

#Create virtual network

#Configure virtual machine

#endregion Virtual Machine


#region Windows Server

# Install Windows Server 2019

# Configure Windows Server

#endregion Windows Server


#region Active Directory domain

# Create Domain Controller

# Create domain

# Configure domain

# Add computer to domain

#endregion Active Directory domain


#region SQL Server
#prereq: server and workstation in domain

# Configure computer for SQL Server

# Prepare SQL Server installation
#   MSA for SSDB and SQL Agent

# Install SQL Server

# Configure SQL Server

# Configure DBA workstation

#region Availability Group
# Prepare primary MSSQL
# Prepare sync MSSQL
# Prepare async MSSQL
# Restore database 
# Create AG
# Configure sync db
# Configure async db
#endregion Availability Group

#endregion SQL Server


#region Windows 10
<#
.DESCRIPTION
  Install Windows 10, add computer til AD domain and harden computer (DoD PAM?)
#>



#endregion Windows 10

function Build-Sandbox {
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
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  #[Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  #[string]$param1
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "[{0:s}Z  BEGIN  ]  Build-Sandbox( 'param1' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  "[{0:s}Z  PROCESS]" -f [System.DateTime]::UtcNow | Write-Verbose
  New-VirtualMachine -Name 'Sandbox00'
}

End {
  $mywatch.Stop()
  [string]$Message = "Build-Platform finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Build-Sandbox()


###  INVOKE  ###
Clear-Host
Build-Sandbox -Verbose #-Debug
