<#
.DESCRIPTION
  Simple trial on using vmrun.exe command tool to work with VMware workstation.

  !!!  Under Construction  !!!
  Not completed as it is not possible to create new VM from scratch using vmrun.
  Not good enough, dear VMware!
  
.LINK
  Microsoft TechNet Script Center: PowerShell GUI for VMware VMRun
  (https://gallery.technet.microsoft.com/scriptcenter/PowerShell-GUI-for-VMware-fdfb2087)
#>

#Requires -Version 7
Set-StrictMode -Version Latest

#Import-Module $PSScriptRoot\vmrun.psm1


#region vmrun
function Test-Administator {
  [CmdletBinding()]
  [OutputType([void])]
  Param()

  Process {
    $isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if (-NOT $isAdministrator) { 
      throw 'You must be running this as local Administrator!'
    }
    else { $true }
  }
}  # Test-Administrator

function Test-User {
  [CmdletBinding()]
  [OutputType([bool])]
  Param()

  Begin {
    $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
    "[{0:s}Z  BEGIN  ]  Test-User()" -f [System.DateTime]::UtcNow | Write-Verbose
  }

  Process {
    [bool]$isAdministrator = Test-Administator
    "::  Administrator = $isAdministrator" | Write-Debug

    if ($isAdministrator) { return $true }
  }

  End {
    $mywatch.Stop()
    [string]$Message = "Test-User finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
    "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
  }
}  # Test-User


function Set-VMrun {
  [CmdletBinding()]
  [OutputType([void])]
  Param()

  Begin {
    $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
    "[{0:s}Z  BEGIN  ]  Set-VMrun()" -f [System.DateTime]::UtcNow | Write-Verbose
  }

  Process {
    [System.IO.FileInfo]$VMwareConfigFile = "${env:ProgramData}\VMware\hostd\config.xml"
    "::  VMware config file: $($VMwareConfigFile.FullName)" | Write-Debug

    $VMwareConfig = [xml](Get-Content $VMwareConfigFile.FullName)
    if ($VMwareConfig -eq $null) { 
      throw [System.IO.FileNotFoundException]"Can't load VMware Workstation config file: $($VMwareConfigFile.BaseName)"
    } 
    else {  
      $WP = $VMwareConfig.config.defaultInstallPath
      [System.IO.DirectoryInfo]$VMwareDirectory = $WP.Trim()
    }
    "::  VMware directory: $($VMwareDirectory.FullName)" | Write-Debug

    if ($VMwareDirectory.Exists) {
      [System.IO.FileInfo]$vmRun = $VMwareDirectory.FullName + 'vmrun.exe'
      if ($vmRun.Exists) { Set-Alias -Name vmrun -Value $vmRun }
      else { throw [System.IO.FileNotFoundException]"vmrun.exe not found." }
      "::  vmrun: $($vmRun.FullName)" | Write-Debug
    }
    else { throw [System.IO.FileNotFoundException]"VMware directory not found." }
  }

  End {
    $mywatch.Stop()
    [string]$Message = "Set-VMrun finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
    "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
  }
}  # Set-VMrun

function Get-VMwarePreferences {
  [CmdletBinding()]
  [OutputType([void])]
  Param()

  Begin {
    $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
    "[{0:s}Z  BEGIN  ]  Get-VMwarePreferences()" -f [System.DateTime]::UtcNow | Write-Verbose
  }

  Process {
    '>>  Get VMware Workstation (roaming) preferences...' | Write-Verbose
    [System.IO.FileInfo]$vmlsFile = "$env:APPDATA\VMware\inventory.vmls"
    if ($vmlsFile.Exists) { "OK - vmls file found ($vmlsFile)." | Write-Verbose }
    else { throw [System.IO.FileNotFoundException] 'vmls file not found.' }

    [string]$VMConfig = Get-Content $vmlsFile | Select-String -Pattern 'index[0-99]\.id'
    "::  $VMConfig"

    '>>  Get VM paths and files from preferences...' | Write-Verbose
    $VMPaths = $VMConfig.Split(' = ')
    "::  VM path count = $($VMPaths.Length)" | Write-Debug
    $VMPreferences = @()  # Array of custom objects
    foreach ($VMPath in $VMPaths) {
      "::  VM path = $VMPath" | Write-Debug
      if ($VMPath -ceq 'index0.id') {
        'INFO - No file path for index 0.' | Write-Verbose
      }
      else {
        $VMMatch = $VMPath -match '\"(.+)\"(.*)'
        if ($VMMatch -eq $true) { 'OK - Valid match on VM path.' | Write-Verbose }
        else { throw "Invalid match on VM path ($VMPath)" }

        [System.IO.FileInfo]$VMFilePath = $Matches[1]
        if ($VMFilePath.Exists) { "OK - VM File Path ($($VMFilePath.Name)) exists." | Write-Verbose }
        else { throw "VM File Path ($($VMFilePath.FullName)) does not exist." }

        [string]$VMindex = $Matches[2].TrimStart()
        if ($VMindex -eq $null -or $VMindex -eq '' -or $VMindex -eq ' ') { "INFO - No index for VM Path ($($VMFilePath.FullName))." | Write-Verbose }

        $VMPreference = New-Object -TypeName psobject
        $VMPreference | Add-Member -MemberType NoteProperty -Name VMFilePath -Value $VMFilePath
        $VMPreference | Add-Member -MemberType NoteProperty -Name VMindex -Value $VMindex
        "::  Matches: File Path = $($VMPreference.VMFilePath) ; index = $($VMPreference.VMindex)" | Write-Debug
        $VMPreferences += $VMPreference
      }
    }
    return $VMPreferences
  }

  End {
    $mywatch.Stop()
    [string]$Message = "Get-VMwarePreferences finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
    "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
  }
}  # Get-VMwarePreferences

function Initialize-VMrun {
  [CmdletBinding()]
  [OutputType([void])]
  Param()

  Begin {
    $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
    "[{0:s}Z  BEGIN  ]  Initialize-VMrun()" -f [System.DateTime]::UtcNow | Write-Verbose
  }

  Process {
    if (Test-User) { '>>  User is OK.' | Write-Verbose }
    else { throw [System.AccessViolationException]'User is not OK.' }

    Set-VMrun

    #$VMwarePreferences = Get-VMwarePreferences
  }

  End {
    $mywatch.Stop()
    [string]$Message = "Initialize-VMrun finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
    "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
  }
}  # Initialize-VMrun

#endregion vmrun


#region WindowsServer

function Build-WindowsServer {
  [CmdletBinding()]
  [OutputType([void])]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
    [string]$ServerName,

    [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
    [System.IO.FileInfo]$ISOFile,

    [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
    [System.IO.DirectoryInfo]$ServerFolder
  )
  
  Begin {
    $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
    "[{0:s}Z  BEGIN  ]  Build-WindowsServer()" -f [System.DateTime]::UtcNow | Write-Verbose
    "::  Server Name  : $ServerName" | Write-Verbose
    "::  ISO file     : $($ISOFile.BaseName)" | Write-Verbose
    "::  Server Folder: $($ServerFolder.FullName)" | Write-Verbose
  }
  
  Process {
    Initialize-VMrun

    
  }

  End {
    $mywatch.Stop()
    [string]$Message = "Build-WindowsServer finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
    "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
  }
}  # Build-WindowsServer

#endregion WindowsServer


###  INVOKE  ###
Clear-Host
#[System.IO.DirectoryInfo]$VMToolFolder = 'C:\Program Files (x86)\VMware\VMware Workstation\'
[System.IO.FileInfo]$ISOFileInfo = '\\192.168.1.252\home\Installation Images\MS Windows Server 2019\en_windows_server_2019_updated_sept_2019_x64_dvd_199664ce.iso'

Build-WindowsServer -ServerName 'myServer' -ISOFile $ISOFileInfo -ServerFolder 'W:\Virtual Machines\' -Verbose #-Debug
