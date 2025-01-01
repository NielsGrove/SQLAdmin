<#
.DESCRIPTION
    PowerShell module that is a interface for SQL Server DBCC CHECKDB.
#>

function Invoke-CheckDb {
    <#
    .DESCRIPTION
        General interface for DBCC CHECKDB.
    .PARAMETER DbInstance
        Name of SQL Server Database Engine instance.
        Server name can be short, full (FQDN), '(local)' or blank. Blank is equal '(local)'.
        Default instance given by blank or '(default)'.
    .PARAMETER Credential
        ToDo
    .PARAMETER DatabaseName
        Name of database. Blank is unknown name [string]
    .PARAMETER DatabaseId
        Database ID in the instance. Positive integer or blank for unknown ID [int]
        If both are blank then the default database of the login is used.
    .PARAMETER Index
        'Yes' or 'No' [string]
    .PARAMETER Repair
        'AllowDataLoss', 'Fast' or 'Rebuild' [string]
    .PARAMETER Messages
        blank, 'All' or 'No' [string]
    .PARAMETER Checks
        blank or 'ExtendedLogical' [string]
    .PARAMETER Lock
        blank or 'Table' [string]
    .PARAMETER Estimate
        blank or 'Only' [string]
    .PARAMETER Physical
        blank or 'Only' [string]
    .PARAMETER DataPurity
        blank or 'Yes' [string]
    .PARAMETER MaxDop
        blank or positive integer [int]
    .PARAMETER WhatIf
        Common parameter [bool]
    .PARAMETER Confirm
        Common parameter [bool]
    .PARAMETER Verbose
        Common parameter [bool]
    .PARAMETER Debug
        Common parameter [bool]
    .OUTPUTS
        (none)
    .RETURNVALUE
        (none)
    .LINK
        Microsoft: DBCC CHECKDB (Transact-SQL)
        <https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-checkdb-transact-sql>
    .EXAMPLE
    #>
    [CmdletBinding()]
    [OutputType([void])]
    Param(
        [Parameter(Mandatory=$false)] [string]$DatabaseName,
        [Parameter(Mandatory=$false)] [int]$DatabaseId
    )

    Begin {
        $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
        "[{0:s}Z  BEGIN  ]  Invoke-CheckDb()" -f [System.DateTime]::UtcNow | Write-Verbose
    }

    Process {
        "[{0:s}Z  PROCESS]" -f [System.DateTime]::UtcNow | Write-Verbose
        [PSObject]$Ssdb = Get-Ssdb -SsdbName $DbInstance #-Credential $Credential

        [PSObject]$Db = Get-Database -Name $DatabaseName -Id $DatabaseId
        "Validated database name = '$DbName'" | Write-Debug
    }

    End {
        $mywatch.Stop()
        [string]$Message = "Invoke-CheckDb finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
        "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output
    }
}  # Invoke-CheckDb


function Get-Ssdb {
     <#
    .DESCRIPTION
        <Description of the function>
    .PARAMETER Name
        Name of SQL Server Database Engine instance [string]
    .OUTPUTS
        (none)
    .RETURNVALUE
        Custom PowerShell object with instance data.
    .LINK
        <link to external reference or documentation>
    #>
    [CmdletBinding()]
    [OutputType([void])]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='')]
        [string]$Name
    )

    Begin {
        $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
        "[{0:s}Z  BEGIN  ]  Get-Ssdb()" -f [System.DateTime]::UtcNow | Write-Verbose
    }

    Process {
        "[{0:s}Z  PROCESS]" -f [System.DateTime]::UtcNow | Write-Verbose
        "Instance name = '$Name'" | Write-Debug
    }

    End {
        $mywatch.Stop()
        [string]$Message = "Get-Ssdb finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
        "[{0:s}Z  END    ]  $Message" -f [System.DateTime]::UtcNow | Write-Output
    }
}  # Get-Ssdb

function Get-DatabaseName {}

Export-ModuleMember -Function *
