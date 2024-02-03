<#
.DESCRIPTION
.PARAMETER <Parameter Name>
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE

.LINK
    Get-Help about_Comment_Based_Help
.LINK
    Microsoft: about_Functions_Advanced
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced
#>

#Requires -Version 7
Set-StrictMode -Version Latest

#Import-Module $PSScriptRoot\sandbox.psm1


#region <name>

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
    #>
    [CmdletBinding()]
    [OutputType([void])]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='Take your time to write a good help message...')]
        [string]$param1
    )

    Begin {
        $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
        "[{0:s}Z  BEGIN  ]  <function name>( '$param1' )" -f [System.DateTime]::UtcNow | Write-Verbose
    }

    Process {
        "[{0:s}Z  PROCESS]" -f [System.DateTime]::UtcNow | Write-Verbose
    }

    End {
        $mywatch.Stop()
        [string]$Message = "<function name> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
        "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output
    }
}  # Verb-Noun()

#endregion <name>


###  INVOKE  ###
Clear-Host
#<function call> -Verbose #-Debug
