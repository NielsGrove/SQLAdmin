<#
.DESCRIPTION
    Test the various Custom Boolean suggestions.
#>
#Requires -Version 7
Set-StrictMode -Version Latest

function Test-CustomBool {
<#
.DESCRIPTION
    Test Custom Boolean
#>
process {
    'Connect to database...' | Write-Verbose
    $SqlCnn = New-Object Microsoft.Data.SqlClient.SqlConnection
    $SqlCnn.ConnectionString = 'Data Source=np:(local)\MSSQL2019;Initial Catalog=custom_bool;Integrated Security = SSPI;TrustServerCertificate=true'

    Test-SimpleFixed -SqlCnn
    Test-UnicodeFixed
    Test-Variable
    Test-UnicodeVariable
    Test-Relation

    'Close connection to database...' | Write-Verbose
}
}  # Test-CustomBool


function Test-SimpleFixed {
<#
.DESCRIPTION
    Test simple fixed Custom Boolean.
.PARAMETER SqlCnn
    SqlConnection object on the database.
#>
[CmdletBinding()]
[OutputType([void])]
Param(
    [Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='')]
    $SqlCnn
)

    $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
    $SqlCmd = New-Object Microsoft.Data.SqlClient.SqlCommand
    $SqlCmd.Connection = $SqlCnn
    $SqlCmd.CommandText = ''
    $SqlCnn.Open()


    $SqlCnn.Close
    $SqlCmd = $null
    $mywatch.Stop()
    [string]$Message = "<function name> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
    "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output
}

function Test-UnicodeFixed {
<#
.DESCRIPTION
    Test Unicode fixed Custom Boolean.
#>
}

function Test-Variable {
<#
.DESCRIPTION
    Test variable Custom Boolean.
#>
}

function Test-UnicodeVariable {
<#
.DESCRIPTION
    Test Unicode variable Custom Boolean.
#>
}

function Test-Relation {
<#
.DESCRIPTION
    Test related type Custom Boolean.
#>
}


### INVOKE ###
Clear-Host
Test-CustomBool -Verbose -Debug
