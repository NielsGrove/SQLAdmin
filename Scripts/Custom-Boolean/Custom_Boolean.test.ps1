<#
.DESCRIPTION
    Test the various Custom Boolean suggestions.
#>
#Requires -Version 7
Set-StrictMode -Version Latest

#region Global
[string]$Script:DataSource = '(local)\SSDB2022'
[string]$Script:InitialCatalog = 'custom_bool'
#endregion Global


function Test-CustomBool {
<#
.DESCRIPTION
    Test Custom Boolean column.
#>
[CmdletBinding()]
[OutputType([void])]
Param(
    #[Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='')]
    #[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection
)
begin {}

process {
    'Connect to database...' | Write-Verbose
    $SqlCnn = New-Object Microsoft.Data.SqlClient.SqlConnection
    $SqlCnn.ConnectionString = 'Data Source=np:(local)\MSSQL2019;Initial Catalog=custom_bool;Integrated Security = SSPI;TrustServerCertificate=true'

    Test-SimpleFixed -SqlConnection $SqlCnn
    #Test-UnicodeFixed
    #Test-Variable
    #Test-UnicodeVariable
    #Test-Relation

    $SqlCnn= $null
}

end {}
}  # Test-CustomBool


function Test-SimpleFixed {
<#
.DESCRIPTION
    Test simple fixed Custom Boolean : Char(5).
.PARAMETER SqlConnection
    SqlConnection object on the database.
#>
[CmdletBinding()]
[OutputType([void])]
Param(
    [Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='')]
    [Microsoft.Data.SqlClient.SqlConnection]$SqlConnection
)
begin {}

process {
    $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
    $SqlCmd = New-Object Microsoft.Data.SqlClient.SqlCommand
    $SqlCmd.Connection = $SqlConnection
    $SqlCmd.CommandText = ''
    $SqlCnn.Open()


    $SqlCnn.Close
    $SqlCmd = $null
    $mywatch.Stop()
    [string]$Message = "Test-SimpleFixed finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
    "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output
}

end {}
}  # Test-SimpleFixed

function Test-UnicodeFixed {
<#
.DESCRIPTION
    Test Unicode fixed Custom Unicode Boolean : NChar(5).
#>
[CmdletBinding()]
[OutputType([void])]
Param(
    #[Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='')]
    #[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection
)
begin {}

process {}

end {}
}  # Test-UnicodeFixed

function Test-Variable {
<#
.DESCRIPTION
    Test variable Custom Boolean.
#>
[CmdletBinding()]
[OutputType([void])]
Param(
    #[Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='')]
    #[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection
)
begin {}

process {}

end {}
}  # Test-Variable

function Test-UnicodeVariable {
<#
.DESCRIPTION
    Test Unicode variable Custom Boolean.
#>
[CmdletBinding()]
[OutputType([void])]
Param(
    #[Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='')]
    #[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection
)
begin {}

process {}

end {}
}  # Test-UnicodeVariable

function Test-Relation {
<#
.DESCRIPTION
    Test related type Custom Boolean.
#>
[CmdletBinding()]
[OutputType([void])]
Param(
    #[Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='')]
    #[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection
)
begin {}

process {}

end {}
}  # Test-Relation


### INVOKE ###
Clear-Host
Test-CustomBool -Verbose -Debug
