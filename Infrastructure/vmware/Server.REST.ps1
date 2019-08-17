<#
.DESCRIPTION
  Set up a virtual machine running Windows Server using VMware Workstation Pro REST API

.LINK
  Using VMware Workstation Pro REST API
  (https://docs.vmware.com/en/VMware-Workstation-Pro/15.0/com.vmware.ws.using.doc/GUID-9FAAA4DD-1320-450D-B684-2845B311640F.html)
#>


#region VMware REST

function Start-VMwareRestApi {
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

  $VMwareInstallDir = 'C:\Program Files (x86)\VMware\VMware Workstation'
}

Process {
  "[{0:s}Z  PROCESS]" -f [System.DateTime]::UtcNow | Write-Verbose

  'Start VMware Workstation REST API...' | Write-Verbose
  $ "$VMwareInstallDir\vmrest.exe"

  "[{0:s}Z  PROCESS]" -f [System.DateTime]::UtcNow | Write-Verbose
  $Credential = Get-Credential
  $Auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Credential.UserName + ':' + $Credential.GetNetworkCredential().Password))
  $head = @{
    'Authorization' = "Basic $Auth"
  }

  $RestApiServer = '127.0.0.1:8697'
  $BaseUri = "http://$RestApiServer"
}

End {
  $mywatch.Stop()
  [string]$Message = "<function name> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output

  return $BaseUri
}
}  # Start-VMwareRestApi()

#endregion VMware REST


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
  <link to external reference or documentation>
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='Short name of new virtual machine.')]
  [string]$Name
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "[{0:s}Z  BEGIN  ]  New-VirtualMachine( 'param1' )" -f [System.DateTime]::UtcNow | Write-Verbose

  $BaseUri = Start-VMwareRestApi
}

Process {
  $vmListUri = $BaseUri + '/api/vms'
  "URI = $vmListUri" | Write-Debug
  $vmList = Invoke-RestMethod -Method Get -Uri $vmListUri -Headers $head #-Type 'application/json'
  $vmList
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
