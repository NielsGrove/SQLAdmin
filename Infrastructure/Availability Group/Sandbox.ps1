<#
.DESCRIPTION
  Clone alle virtual machines used for the sandbox.
#>

#Requires -Version 5
Set-StrictMode -Version Latest

#region Network

function New-Network {
    <#
    .DESCRIPTION
    Create virtual network for sandbox.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    Param()

    Begin {}

    Process {}

    End {}
}

#endregion Network


#region CloneVM

function New-DC {
    <#
    .DESCRIPTION
    Create AD Domain Controller to host domain in the sandbox.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    Param ()

    Begin {}

    Process {
        [string]$vmrun = "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmrun.exe"
        "vmrun: '$vmrun'."
        [string]$DCName = 'DC00'
        [System.IO.FileInfo]$SourceWmx = 'W:\Virtual Machines\Windows Server 2019 Std Ed\Windows Server 2019 Std Ed.vmx'
        "Source WMX-file: '$SourceWmx'." #| Write-Debug
        [string]$TargetWmx = "W:\Virtual Machines\$DCName\$DCName.wmx"
        "Target WMX-file: '$TargetWmx'." #| Write-Debug
        [string]$cloneCmd = "$vmrun clone -T ws `"$SourceWmx`" `"$TargetWmx`" full -cloneName=$DCName"
        "clone: $cloneCmd"
        '-'*42
        
        & ($vmrun) ('clone -T ws')
        #& $vmrun "clone -T ws `"$SourceWmx`" `"$TargetWmx`" full -cloneName=$DCName"
        #Start-Process -FilePath 'vmrun.exe' -WorkingDirectory "${env:ProgramFiles(x86)}\VMware\VMware Workstation" -ArgumentList 'clone -T ws' -Wait
        #Start-Process -FilePath 'vmrun.exe' -WorkingDirectory "${env:ProgramFiles(x86)}\VMware\VMware Workstation" -ArgumentList "clone -T ws `"$SourceWmx`" `"$TargetWmx`" full -cloneName=$DCName"
        #.\vmrun.exe clone -T ws "`"$SourceWmx`"" "`"$TargetWmx`"" full -cloneName=$DCName

        <#$ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
        $ProcessInfo.FileName = $vmrun
        $ProcessInfo.RedirectStandardError = $true
        $ProcessInfo.RedirectStandardOutput = $true
        $ProcessInfo.UseShellExecute = $false
        $ProcessInfo.Arguments = 'clone -T ws'
        $Process = New-Object System.Diagnostics.Process
        $Process.StartInfo = $ProcessInfo
        $Process.Start()
        $Process.WaitForExit()
        $StdOut = $Process.StandardOutput.ReadToEnd()
        $StdErr = $Process.StandardError.ReadToEnd()
        "StdOut: $StdOut"
        "StdErr: $StdErr"
        "Exit Code: $($Process.ExitCode)"#>
    }

    End {}
}  # New-DC()



function New-Workstation {
    <#
    .DESCRIPTION
    Create workstation with tools in sandbox to work with the components.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    Param ()

    Begin {}

    Process {}

    End {}
}  # New-Workstation

function New-FileServer {
    <#
    .DESCRIPTION
    Create file server for cluster quorum to the Availability Group cluster in the sandbox.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    Param ()

    Begin {}

    Process {}

    End {}
}
function New-DatabaseServer {
    <#
    .DESCRIPTION
    Create SQL Server database server to host Availability Group in sandbox.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    Param(
        [string]$AGRole  # { 'Primary' | 'Secondary' | 'Tertiary' }
    )

    Begin {}

    Process {}

    End {}
}

#endregion CloneVM

function New-Sandbox {
    <#
    .DESCRIPTION
    #>
    [CmdletBinding()]
    [OutputType([void])]
    Param()

    Begin {
        [System.IO.DirectoryInfo]$VMwarePath = "${env:ProgramFiles(x86)}\VMware\VMware Workstation"
        Push-Location -LiteralPath $VMwarePath
    }

    Process {
        'New network...' | Write-Verbose
        New-Network

        'New DC...' | Write-Verbose
        New-DC

        'New Workstation...' | Write-Verbose
        New-Workstation

        'New file server...' | Write-Verbose
        New-FileServer

        'New database server A...' | Write-Verbose
        New-DatabaseServer -AGRole 'Primary'

        'New database server B...' | Write-Verbose
        New-DatabaseServer -AGRole 'Secondary'

        'New database server C...' | Write-Verbose
        New-DatabaseServer -AGRole 'Tertiary'
    }

    End {
        Pop-Location
    }
}  # New-Sandbox()


###  INVOKE  ###
#Clear-Host

New-Sandbox -Verbose #-Debug
