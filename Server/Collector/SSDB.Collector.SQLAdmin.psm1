<#
.DESCRIPTION
  Collect data on SQL Server Database Engine (SSDB) installation.
  Data are stored in SQLAdmin Inventory.

.NOTES
  2015-04-23 (NGR) File created.
  2017-07-01 (Niels Grove-Rasmussen) Move from Codeplex to GitHub.
#>

# Requires -Version 4.0

Set-StrictMode -Version Latest

#ToDo : Refactor to use PowerShell modules
[string]$script:ScriptPath = 'D:\MSSQL\MSSQL10_50.MSSQL\MSSQL\JOBS'
. "$ScriptPath\SqlAdmin.Core.ps1" 

':: SQLAdmin SSDB' | Write-Verbose


#region SSDB

function Get-SsdbInfo {
<#
.DESCRIPTION
Get details on SQL Server Database Engine installation (instance).
.PARAMETER ComputerName
.PARAMETER SsdbName
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory=$true)]
  [string]$ComputerName,

  [Parameter(Mandatory=$true)]
  [string]$SsdbName
)

Begin {}

Process {
  # SERVERPROPERTY
  #  https://msdn.microsoft.com/en-us/library/ms174396.aspx
  [string]$Version
  [string]$Edition
  $TcpPort
  [string]$Collation
  $AuditLevel
  [string]$BackupPath
  [Int]$ErrorLogCount
  [string]$ErrorLogPath
  [string]$DataPath
  [string]$TranslogPath
  [string]$ServiceAccount
  [Bool]$IsFullTextInstalled
  $LoginMode
  [Bool]$IsSingleUser
  [string]$ClrVersion
  [Bool]$IsPagesLockedInMemory
  [string]$Description

  # sp_configure:
  #  https://msdn.microsoft.com/en-us/library/ms189631.aspx
  # sys.configurations
  #  https://msdn.microsoft.com/en-us/library/ms188345.aspx
  [Bool]$IsAdHocDistributedQueries
  [Int]$AffinityIOMask  # 32/64 bit
  [Int]$AffinityMask  # 32/64 bit
  [Bool]$IsBackupCompressed
  [Bool]$IsC2AuditMode
  [Bool]$IsClrEnabled
  [Bool]$IsCommonCriteriaEnabled
  [Int]$CostThresholdParalism
  [Bool]$CrossDbOwnershipChaining
  [Bool]$IsDatabaseMailXps
  [Bool]$IsDefaultTraceEnabled
  [Int]$MaxDop
  [Int]$MaxMem
  [Int]$MinMem
  [Int]$NetworkPacketSize
  [Bool]$IsOleAutomationEnabled
  [Bool]$IsOptimizeForAdHocWorkloads
  [Bool]$IsShowAdvancedOptions
  [Bool]$IsXpCmdshell

  #End points: (sys.endpoints ???)
  #  https://msdn.microsoft.com/en-us/library/ms189746.aspx

  # Trace Flags
  #  DBCC TRACESTATUS : https://msdn.microsoft.com/en-us/library/ms187809.aspx3


  #SQL Server Browser Service

  #SQL Server Agent

  $Ssdb = [PSCustomObject]@{
    'Version' = $Version;
    'Edition' = $Edition
  }
}

End {}
}  # Get-SsdbInfo()

function Get-SsdbDetail {
<#
.DESCRIPTION
  Get details on SQL Server Database Engine installation (instance).
.PARAMETER ComputerName
.PARAMETER SsdbName
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory=$true)]
  [string]$ComputerName,

  [Parameter(Mandatory=$true)]
  [string]$SsdbName
)

Begin {}

Process {
	if ($SsdbName -eq '.') { [String]$SsdbName_Full = $ComputerName }
	else { [String]$SsdbName_Full = $ComputerName + '\' + $SsdbName }
	"{0:s}  Updating details on `"$SsdbName_Full`"..." -f $([System.DateTime]::Now) | Write-Verbose
	
	$smoServer = New-Object Microsoft.SqlServer.Management.Smo.Server $SsdbName_Full
	$smoServer.ConnectionContext.StatementTimeout = 6
	$smoServer.ConnectionContext.ConnectTimeout = 10
	
	"Get detail data from installation" | Write-Verbose
	$VersionMajor = $smoServer.VersionMajor
	if ($VersionMajor -eq $null) {
		"{0:s}  Could not get SMO.Server.VersionMajor of `"$SsdbName_Full`". Skipping detail data collection." -f $([System.DateTime]::Now) | Write-Output
		return $null
	}
	[string]$Version = [String]$smoServer.Version
	[string]$Collation = $smoServer.Collation
	#$TcpPort = Get-SqlTcp -ComputerName $ComputerName -DbInstanceName $SsdbName
	[string]$AuditLevel = $smoServer.AuditLevel
	[string]$Edition = $smoServer.Edition
	$MaxMem = $smoServer.Configuration.MaxServerMemory.RunValue
	$MinMem = $smoServer.Configuration.MinServerMemory.RunValue
	$MaxDop = $smoServer.Configuration.MaxDegreeOfParallelism.RunValue
	[string]$BackupPath = $smoServer.BackupDirectory
	[Bool]$IsBackCompressed = [Bool]$smoServer.Configuration.DefaultBackupCompression.RunValue
	$ErrorLogCount = $smoServer.NumberOfLogFiles
	[string]$ErrorLogPath = $smoServer.ErrorLogPath
	[string]$DataPath = $smoServer.DefaultFile
	[string]$LogPath = $smoServer.DefaultLog
	[string]$ServiceAccount = $smoServer.ServiceAccount
	$IsFullTextInstalled = $smoServer.IsFullTextInstalled
	$LoginMode = $smoServer.LoginMode
	$IsSingleUser = $smoServer.IsSingleUser
	[Bool]$IsOleAutomationEnabled = [Bool]$smoServer.Configuration.OleAutomationProceduresEnabled.RunValue
	if ($smoServer.BuildClrVersion -eq $null) { [string]$ClrVersion = $null }
	else { [string]$ClrVersion = [string]$smoServer.BuildClrVersion }
	[Bool]$IsClrEnabled = [Bool]$smoServer.Configuration.IsSqlClrEnabled.RunValue
	#$IsPagesLockedInMemory = $null
	#$LicenseCount = $null
	$Description = $null
	$smoServer = $null
	
	"Insert detail data in SQLAdmin Repository" | Write-Verbose
	$strSqladmin = "Server=$SqladminSsdb;Integrated Security=SSPI;Database=$SqladminDb;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"
	$cnnSqladmin = New-Object System.Data.SqlClient.SqlConnection
	$cnnSqladmin.ConnectionString = $strSqladmin
	$cnnSqladmin.Open()
	$cmdSqladmin = New-Object System.Data.SqlClient.SqlCommand '[sqladmin].[ssdb-set]', $cnnSqlAdmin
	$cmdSqladmin.CommandType = [System.Data.CommandType]::StoredProcedure
	$cmdSqladmin.Parameters.Add('@computer_name', [System.Data.SqlDbType]::NVarChar, 128).Value = $ComputerName
	$cmdSqladmin.Parameters.Add('@ssdb_name', [System.Data.SqlDbType]::NVarChar, 128).Value = $SsdbName
	$cmdSqladmin.Parameters.Add('@ssdb_edition', [System.Data.SqlDbType]::NVarChar, 128).Value = $Edition
	$cmdSqladmin.Parameters.Add('@ssdb_version', [System.Data.SqlDbType]::NVarChar, 128).Value = $Version
	$cmdSqladmin.Parameters.Add('@collation_name', [System.Data.SqlDbType]::NVarChar, 128).Value = $Collation
	#$cmdSqladmin.Parameters.Add('@ssdb_tcp_port', [System.Data.SqlDbType]::Int).Value = $TcpPort
	#$cmdSqladmin.Parameters.Add('@ssdb_is_tcp_dynamic', [System.Data.SqlDbType]::Bit).Value = $IsTcpDynamic
	$cmdSqladmin.Parameters.Add('@ssdb_audit_level', [System.Data.SqlDbType]::NVarChar, 128).Value = $AuditLevel
	$cmdSqladmin.Parameters.Add('@ssdb_maxmem_in_mb', [System.Data.SqlDbType]::Int).Value = $MaxMem
	$cmdSqladmin.Parameters.Add('@ssdb_minmem_in_mb', [System.Data.SqlDbType]::Int).Value = $MinMem
	$cmdSqladmin.Parameters.Add('@ssdb_maxdop', [System.Data.SqlDbType]::Int).Value = $MaxDop
	$cmdSqladmin.Parameters.Add('@ssdb_backup_path', [System.Data.SqlDbType]::NVarChar, 128).Value = $BackupPath
	$cmdSqladmin.Parameters.Add('@ssdb_is_backup_compressed', [System.Data.SqlDbType]::Bit).Value = $IsBackupCompressed
	$cmdSqladmin.Parameters.Add('@ssdb_errorlog_count', [System.Data.SqlDbType]::Int).Value = $ErrorLogCount
	$cmdSqladmin.Parameters.Add('@ssdb_errorlog_path', [System.Data.SqlDbType]::NVarChar, 128).Value = $ErrorLogPath
	$cmdSqladmin.Parameters.Add('@ssdb_data_path', [System.Data.SqlDbType]::NVarChar, 128).Value = $DataPath
	$cmdSqladmin.Parameters.Add('@ssdb_log_path', [System.Data.SqlDbType]::NVarChar, 128).Value = $LogPath
	$cmdSqladmin.Parameters.Add('@ssdb_serviceaccount', [System.Data.SqlDbType]::NVarChar, 128).Value = $ServiceAccount
	$cmdSqladmin.Parameters.Add('@ssdb_is_fulltext_installed', [System.Data.SqlDbType]::Bit).Value = $IsFullTextInstalled
	$cmdSqladmin.Parameters.Add('@ssdb_loginmode', [System.Data.SqlDbType]::NVarChar, 128).Value = $LoginMode
	$cmdSqladmin.Parameters.Add('@ssdb_is_single_user', [System.Data.SqlDbType]::Bit).Value = $IsSingleUser
	$cmdSqladmin.Parameters.Add('@ssdb_is_oleautomation_enabled', [System.Data.SqlDbType]::Bit).Value = $IsOleAutomationEnabled
	$cmdSqladmin.Parameters.Add('@ssdb_clr_version', [System.Data.SqlDbType]::NVarChar, 128).Value = $ClrVersion
	$cmdSqladmin.Parameters.Add('@ssdb_is_clr_enabled', [System.Data.SqlDbType]::Bit).Value = $IsClrEnabled
	#$cmdSqladmin.Parameters.Add('@ssdb_is_pages_locked_in_memory', [System.Data.SqlDbType]::Bit).Value = $IsPagesLockedInMemory
	#$cmdSqladmin.Parameters.Add('@ssdb_license_count', [System.Data.SqlDbType]::Int).Value = $LicenseCount
	$cmdSqladmin.Parameters.Add('@ssdb_description', [System.Data.SqlDbType]::NVarChar, 256).Value = $Description
	try { [Int]$rc = $cmdSqladmin.ExecuteNonQuery() }
	catch { throw $_ }
	$cmdSqladmin = $null
	$cnnSqladmin.Close()
	$cnnSqladmin = $null
	
	if ($rc -ne -1) { "{0:s}  Update on `"$SsdbName_Full`" failed. Return value = `"$rc`"." -f $([System.DateTime]::Now) | Write-Output }
	else { "{0:s}  `"$SsdbName_Full`" updated with success." -f $([System.DateTime]::Now) | Write-Output }
}

End {}
}  # Get-SsdbDetail()


function Get-MsSqlDbTcp {
<#
.DESCRIPTION
  Get TCP port of a SQL Server Database Engine installation (instance).

ToDo : Registration structure differs from TCP port registration.
  IsTcpDynamic = $reg.GetStringValue($HKLM, $regPath, 'TcpDynamicPorts').svalue
  Write-Debug "Is TCP dynamic= $IsTcpDynamic"

ToDo : Requires access to read registry
.PARAMETER ComputerName
.PARAMETER SsdbName
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory=$true)]
  [string]$ComputerName,

  [Parameter(Mandatory=$true)]
  [string]$SsdbName
)

Begin {}

Process {
  Write-Debug ":: Get-SqlTcp -ComputerName '$ComputerName' -DbInstanceName '$DbInstanceName'"

  if ($DbInstanceName -eq '.')
  {$sqlName = 'MSSQLSERVER' }
  else
  { $sqlName = $DbInstanceName }

  $HKLM = 2147483650
  [WMIClass]$reg = "\\$ComputerName\root\default:stdRegProv"
  $SqlVersionMajor = Get-SqlVersionMajor -ComputerName $ComputerName -DbInstanceName $DbInstanceName
	
  "Default instance, SQL 2000" | Write-Verbose
  if ($DbInstanceName -eq '.') {
    $regPath = 'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer\SuperSocketNetLib\Tcp'
  }

  "Named instance, SQL 2000" | Write-Verbose
  if ($DbInstanceName -ne '.' -and $SqlVersionMajor -eq 8) {
    $regPath = "SOFTWARE\Microsoft\Microsoft SQL Server\$sqlName\MSSQLServer\SuperSocketNetLib\Tcp"
  }
	
  "SQL 2005 default instance" | Write-Verbose
  if ($SqlVersionMajor -eq 9) {
    (1..50) | ForEach-Object {
      $_regPath_ = "SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL.$_"
      if ($reg.GetStringValue($HKLM,$_regPath_,"").svalue -eq $sqlName) {
        $regPath ="SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL.$_\MSSQLServer\SuperSocketNetLib\tcp\IPAll"
      }
    }
  }
	
  "Named instance, SQL 2008 (R2)" | Write-Verbose
  if ($DbInstanceName -ne '.' -and $SqlVersionMajor -eq 10) {
    $regPath = "SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10.$sqlName\MSSQLServer\SuperSocketNetLib\Tcp\IPAll"
  }

  $TcpPort = $reg.GetStringValue($HKLM, $regPath, 'TcpPort').svalue
  Write-Debug "TCP Port      = $TcpPort"
  $TcpPort
}

End {}
}


function Get-SsdbVersionMajor {
<#
.DESCRIPTION
  Get Major Version of SQL Server Database Engine (SSDB) version number.
  The function does not contact the SSDB instance.
.PARAMETER
.INPUTS
.OUTPUTS
.RETURNVALUE
  SSDB major version number [Integer].
.NOTES
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory=$true)]
  [string]$Version
)

Begin {}

Process {
  [Int]$VersionMajor = $Version.Split('.')[0]
  Write-Debug "SSDB version $Version, major = $VersionMajor."

  $VersionMajor
}

End {}
}


function Get-SqlAdminSsdb {
<#
.DESCRIPTION
  Get list of SQL Server Database Engine installations (instance) registered in the SQLAdmin Repository.
.PARAMETER
  (none)
.INPUTS
.OUTPUTS
.RETURNVALUE
.NOTES
#>
[CmdletBinding()]
param()

Begin {}

Process {
	[string]$strSqladmin = "Server=$SqladminSsdb;Integrated Security=SSPI;Database=$SqladminDb;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"
	$cnnSqladmin = New-Object System.Data.SqlClient.SqlConnection
	$cnnSqladmin.ConnectionString = $strSqladmin
	try { $cnnSqladmin.Open() }
	catch { throw $_ }
	[string]$dml = 'SELECT [computer_name],[ssdb_name] FROM [sqladmin].[v_ssdb];'
	$ds = New-Object System.Data.DataSet
	$da = New-Object System.Data.SqlClient.SqlDataAdapter $dml, $cnnSqladmin
	$rc = $da.Fill($ds)
	$cnnSqladmin.Close()
	$cnnSqladmin = $null

	$ds.Tables[0]
}

End {}
}


function Find-MsSqlSsdb {
<#
.DESCRIPTION
  Find a SQL Server Database Engine installation on a given computer.
.PARAMETER
.INPUTS
  (none)
.OUTPUTS
  (none)
.RETURNVALUE
.NOTES
  2015-02-16  (Niels Grove-Rasmussen) Function created.
#>
[CmdletBinding()]
[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
param(
  [Parameter(Mandatory=$true)]
  [string]$ComputerName = "."
)

Begin {
}

Process {	
  "Find-MsSqlSsdb( '$ComputerName' )" | Write-Verbose

  [string]$WQL = "SELECT Name, Started, StartMode, StartName, State, Status, SystemName FROM Win32_Service WHERE (Name LIKE 'MSSQLSERVER' OR Name LIKE 'MSSQL$%')"
	
  Get-WmiObject -query $WQL -computerName $ComputerName | 
  ForEach-Object { 
    Switch( $_.Name.split("$")[1] ) { 
      $null { $InstanceName = '.' } 
      Default { $InstanceName = $_ } 
    }
    Write-Output $InstanceName
  }
}

End {}
}  # Find-MsSqlSsdb()

#endregion SSDB


#region Database

# Select DATABASEPROPERTY and DATABASEPROPERTYEX...

function Get-Database {
<#
.DESCRIPTION
  Get database metadata ('info') from a SQL Server Database Engine installation (instance).
.PARAMETER <Parameter Name>
.INPUTS
.OUTPUTS
.RETURNVALUE
  Array of custom objects representing database metadata.
#>
[CmdletBinding()]
param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[string]$SsdbFullName
)
Begin {}

Process {
	"{0:s}Z  Get database info on `"$SsdbName_Full`"..." -f $([System.DateTime]::UtcNow) | Write-Output

	$StrSql = "Data Source=$SsdbName_Full;Integrated Security=SSPI;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"
	$CnnSql = New-Object System.Data.SqlClient.SqlConnection $StrSql
	try { $CnnSql.Open() }
	catch {
		"{0:s}Z  Could not open $strSql" -f $([System.DateTime]::UtcNow) | Write-Output
		return
	}
	"Server Version = $($CnnSql.ServerVersion)" | Write-Debug
	[Int32]$VersionMajor = $CnnSql.ServerVersion.Split('.')[0]
	"Version Major = $VersionMajor" | Write-Debug
	
    "Get info on all databases in SSDB instance." | Write-Verbose
	if ($VersionMajor -eq 8) { Return $null }  # master.sys.databases on SQL Server 2005 and newer
	
	[string]$SqlCommand = @"
SELECT
	[databases].[name],
	[server_principals].[name] AS [owner_name],
	[databases].[create_date],
	[databases].[compatibility_level],
	[databases].[collation_name],
	(SELECT TOP 1 [backupset].[backup_finish_date]
	FROM [msdb].[dbo].[backupset]
	WHERE [backupset].[type] = 'D' AND [backupset].[database_name] = [databases].[name]
	ORDER BY [backupset].[backup_finish_date] DESC) AS [last_database_backup],
	(SELECT TOP 1 [backupset].[backup_finish_date]
	FROM [msdb].[dbo].[backupset]
	WHERE [backupset].[type] = 'I' AND [backupset].[database_name] = [databases].[name]
	ORDER BY [backupset].[backup_finish_date] DESC) AS [last_differential_backup],
	(SELECT TOP 1 [backupset].[backup_finish_date]
	FROM [msdb].[dbo].[backupset]
	WHERE [backupset].[type] = 'L' AND [backupset].[database_name] = [databases].[name]
	ORDER BY [backupset].[backup_finish_date] DESC) AS [last_translog_backup],
	[databases].[user_access],
	[databases].[is_read_only],
	[databases].[is_auto_close_on],
	[databases].[is_auto_shrink_on],
	[databases].[state],
	[databases].[snapshot_isolation_state],
	[databases].[is_read_committed_snapshot_on],
	[databases].[recovery_model],
	[databases].[page_verify_option],
	[databases].[is_auto_create_stats_on],
	[databases].[is_auto_update_stats_on],
	[databases].[is_fulltext_enabled],
	[databases].[is_trustworthy_on],
	[databases].[is_db_chaining_on],
	[databases].[is_published],
	[databases].[is_subscribed],
	[databases].[is_merge_published],
	[databases].[is_distributor],
	[databases].[is_broker_enabled],
    [databases].[is_encrypted]
FROM [master].[sys].[databases]
INNER JOIN [master].[sys].[server_principals] ON [databases].[owner_sid] = [server_principals].[sid];
"@
	$CmdSql = New-Object System.Data.SqlClient.SqlCommand $SqlCommand, $CnnSql

	$Databases = @()
	
	[System.Data.SqlClient.SqlDataReader]$RdrSsdb = $CmdSql.ExecuteReader()
	if ($RdrSsdb.HasRows) {
		"sysDatabases Count = $($RdrSsdb.FieldCount)" | Write-Debug

		while($RdrSsdb.Read()) {
			[PSObject]$SqlDb = New-Object -TypeName PSObject
			$SqlDb.PSObject.TypeNames.Insert(0,'SqlAdmin.SqlDb')
            
			[String]$Name = $RdrSsdb.GetString($RdrSsdb.GetOrdinal('name'))
			"Database Name = [$Name]" | Write-Debug
			Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name Name -Value $Name
	
            "   database_instance_name = $SsdbName" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name DbInstanceName -Value $SsdbFullName

			[String]$OwnerName = $RdrSsdb.GetString($RdrSsdb.GetOrdinal('owner_name'))
            "   owner_name = $OwnerName" | Write-Debug
			Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name OwnerName -Value $OwnerName

			[DateTime]$CreateTime = $RdrSsdb.GetDateTime($RdrSsdb.GetOrdinal('create_date'))
            "   create_time = {0:s}" -f $CreateTime | Write-Debug
			Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name CreateTime -Value $CreateTime
			
			[Int16]$CompatibilityLevel = $RdrSsdb.GetValue($RdrSsdb.GetOrdinal('compatibility_level'))
            "   compatibility_level = $CompatibilityLevel" | Write-Debug
			Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name CompatibilityLevel -Value $CompatibilityLevel
			
			[String]$CollationName = $RdrSsdb.GetString($RdrSsdb.GetOrdinal('collation_name'))
            "   collation_name = $CollationName" | Write-Debug
			Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name CollationName -Value $CollationName
            
            if ($RdrSsdb.IsDBNull($RdrSsdb.GetOrdinal('last_database_backup')))
            { [DateTime]$BackupFullLast = 0 }
            else
            { [DateTime]$BackupFullLast = $RdrSsdb.GetDateTime($RdrSsdb.GetOrdinal('last_database_backup')) }
            "   last_database_backup = {0:s}" -f $BackupFullLast | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name BackupFullLast -Value $BackupFullLast

            if ($RdrSsdb.IsDBNull($RdrSsdb.GetOrdinal('last_differential_backup')))
            { [DateTime]$BackupDiffLast = 0 }
            else
            { [DateTime]$BackupDiffLast = $RdrSsdb.GetDateTime($RdrSsdb.GetOrdinal('last_differential_backup')) }
            "   last_differential_backup = {0:s}" -f $BackupDiffLast | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name BackupDiffLast -Value $BackupDiffLast

            if ($RdrSsdb.IsDBNull($RdrSsdb.GetOrdinal('last_translog_backup')))
            { [DateTime]$BackupLogLast = 0 }
            else
            { [DateTime]$BackupLogLast = $RdrSsdb.GetDateTime($RdrSsdb.GetOrdinal('last_translog_backup')) }
            "   last_translog_backup = {0:s}" -f $BackupLogLast | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name BackupLogLast -Value $BackupLogLast
			
			[Int16]$UserAccess = $RdrSsdb.GetValue($RdrSsdb.GetOrdinal('user_access'))
            "   user_access = $UserAccess" | Write-Debug
			Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name UserAccess -Value $UserAccess

	        [Bool]$IsReadOnly = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_read_only'))
            "   is_read_only = $IsReadOnly" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsReadOnly -Value $IsReadOnly

	        [Bool]$IsAutoCloseOn = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_auto_close_on'))
            "   is_auto_close_on = $IsAutoCloseOn" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsAutoCloseOn -Value $IsAutoCloseOn

	        [Bool]$IsAutoShrinkOn = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_auto_shrink_on'))
            "   is_auto_shrink_on = $IsAutoShrinkOn" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsAutoShrinkOn -Value $IsAutoShrinkOn

            [Int16]$State = $RdrSsdb.GetValue($RdrSsdb.GetOrdinal('state'))
            switch ($State) {
                0 { [String]$StateDescription = 'Online' }
                1 { [String]$StateDescription = 'Restoring' }
                2 { [String]$StateDescription = 'Recovering' }
                3 { [String]$StateDescription = 'Recovery Pending' }
                4 { [String]$StateDescription = 'Suspect' }
                5 { [String]$StateDescription = 'Emergency' }
                6 { [String]$StateDescription = 'Offline' }
                7 { [String]$StateDescription = 'Copying (Azure SQL)' }
                default { [String]$StateDescription = '(UNKNOWN : $State)' }
            }
            "   state = $StateDescription ($State)" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name State -Value $StateDescription

            [Int16]$SnapshotIsolationState = $RdrSsdb.GetValue($RdrSsdb.GetOrdinal('snapshot_isolation_state'))
            "   snapshot_isolation_state = $SnapshotIsolationState" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name SnapshotIsolationState -Value $SnapshotIsolationState
            
            [Bool]$IsReadCommittedSnapshotOn = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_read_committed_snapshot_on'))
            "   is_read_committed_snapshot_on = $IsReadCommittedSnapshotOn" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsReadCommittedSnapshotOn -Value $IsReadCommittedSnapshotOn
            
            [Int16]$RecoveryModel = $RdrSsdb.GetValue($RdrSsdb.GetOrdinal('recovery_model'))
            switch ($RecoveryModel) {
                1 { [String]$RecoveryModelDescription = 'Full' }
                2 { [String]$RecoveryModelDescription = 'Bulk Logged' }
                3 { [String]$RecoveryModelDescription = 'Simple' }
                default { [String]$RecoveryModelDescription = "(UNKNOWN : $RecoveryModel)" }
            }
            "   recovery_model = $RecoveryModelDescription ($RecoveryModel)" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name RecoveryModel -Value $RecoveryModelDescription
            
            [Int16]$PageVerifyOption = $RdrSsdb.GetValue($RdrSsdb.GetOrdinal('page_verify_option'))
            switch ($PageVerifyOption) {
                0 { [String]$PageVerifyOptionDescription = 'None' }
                1 { [String]$PageVerifyOptionDescription = 'Torn Page Detection' }
                2 { [String]$PageVerifyOptionDescription = 'Checksum' }
                default { [String]$PageVerifyOptionDescription = '(UNKNOWN : $PageVerifyOption)' }
            }
            "   page_verify_option = $PageVerifyOptionDescription ($PageVerifyOption)" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name PageVerifyOption -Value $PageVerifyOptionDescription
            
            [Bool]$IsAutoCreateStatsOn = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_auto_create_stats_on'))
            "   is_auto_create_stats_on = $IsAutoCreateStatsOn" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsAutoCreateStatsOn -Value $IsAutoCreateStatsOn
            
            [Bool]$IsAutoUpdateStatsOn = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_auto_update_stats_on'))
            "   is_auto_update_stats_on = $IsAutoUpdateStatsOn" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsAutoUpdateStatsOn -Value $IsAutoUpdateStatsOn
            
            [Bool]$IsFulltextEnabled = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_fulltext_enabled'))
            "   is_fulltext_enabled = $IsFulltextEnabled" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsFulltextEnabled -Value $IsFulltextEnabled
            
            [Bool]$IsTrustworthyOn = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_trustworthy_on'))
            "   is_trustworthy_on = $IsTrustworthyOn" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsTrustworthyOn -Value $IsTrustworthyOn
            
            [Bool]$IsDbChainingOn = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_db_chaining_on'))
            "   is_db_chaining_on = $IsDbChainingOn" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsDbChainingOn -Value $IsDbChainingOn
            
            [Bool]$IsPublished = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_published'))
            "   is_published = $IsPublished" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsPublished -Value $IsPublished
            
            [Bool]$IsSubscribed = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_subscribed'))
            "   is_subscribed = IsSubscribed" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsSubscribed -Value $IsSubscribed
            
            [Bool]$IsMergePublished = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_merge_published'))
            "   is_merge_published = $IsMergePublished" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsMergePublished -Value $IsMergePublished
            
            [Bool]$IsDistributor = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_distributor'))
            "   is_distributor = $IsDistributor" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsDistributor -Value $IsDistributor
            
            [Bool]$IsBrokerEnabled = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_broker_enabled'))
            "   is_broker_enabled = $IsBrokerEnabled" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsBrokerEnabled -Value $IsBrokerEnabled

            [Bool]$IsEncrypted = $RdrSsdb.GetBoolean($RdrSsdb.GetOrdinal('is_encrypted'))
            "   is_encrypted = $IsEncrypted" | Write-Debug
            Add-Member -InputObject $SqlDb -MemberType NoteProperty -Name IsEncrypted -Value $IsEncrypted
			
			$Databases += $SqlDb
			$SqlDb = $null
		}
	}
	$RdrSsdb.Close()
	$CnnSql.Close()

	"Get info from each individual database." | Write-Verbose
	$Databases |
    ForEach-Object {
        "Get database description from extended property 'MS_Description'." | Write-Verbose
        "$($_.Name)" | Write-Debug
        if ($_.Name -eq 'master' -or $_.Name -eq 'msdb' -or $_.Name -eq 'model' -or $_.Name -eq 'tempdb')
        { [string]$Description = 'SQL Server system database.' }
        else {
            $SqlCommand = @"
SELECT [value] AS [description]
FROM [$($_.Name)].sys.[extended_properties]
WHERE [class] = 0 AND [name]=N'MS_Description';
"@
            $ds = New-Object System.Data.DataSet
            $CnnSql.Open()
            $da = New-Object System.Data.SqlClient.SqlDataAdapter $SqlCommand, $CnnSql
            $rc = $da.Fill($ds)
            $CnnSql.Close()
            if ($ds.Tables[0].Rows[0] -eq $null)
            { [string]$Description = '' }
            else
	        { [string]$Description = $ds.Tables[0].Rows[0].description }
        }
        "   Descripotion: $Description" | Write-Debug
        Add-Member -InputObject $_ -MemberType NoteProperty -Name Description -Value $Description
    }

    $Databases
}

End {}
}  # Get-Database()


function Set-Database {  #Write-SqlAdminSsdbDatabase
<#
.DESCRIPTION
Write SQL Server Database Engine database metadata in the SQLAdmin Repository.
.PARAMETER <Parameter Name>
.INPUTS
.OUTPUTS
.RETURNVALUE
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory=$true)]
  [string]$ComputerName,

  [Parameter(Mandatory=$true)]
  [string]$SsdbName
)

Begin {}

Process {
	if ($SsdbName -eq '.') { $SsdbName_Full = $ComputerName }
	else { $SsdbName_Full = $ComputerName + '\' + $SsdbName }
	"{0:s}Z  Updating details on `"$SsdbName_Full`"..." -f $([System.DateTime]::UtcNow) | Write-Output
	
	"Set all database registrations in the SQLAdmin Repository not active." | Write-Verbose
	[string]$strSqladmin = "Data Source=$SqladminSsdb;Integrated Security=SSPI;Initial Catalog=$SqladminDb;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"
	$cnnSqladmin = New-Object System.Data.SqlClient.SqlConnection $strSqladmin
	try { $cnnSqladmin.Open() }
	catch {
		"{0:s}  Could not open $strSqladmin" -f $([System.DateTime]::Now) | Write-Output
		return
	}
	<#$cmdSqladmin = New-Object System.Data.SqlClient.SqlCommand '[sqladmin].[database_all_by_ssdb_not_active-set]', $cnnSqlAdmin
	$cmdSqladmin.CommandType = [System.Data.CommandType]::StoredProcedure
	$cmdSqladmin.Parameters.Add('@computer_name', $ComputerName) | Out-Null
	$cmdSqladmin.Parameters.Add('@ssdb_name', $SsdbName) | Out-Null
	try { $rc = $cmdSqladmin.ExecuteNonQuery() }
	catch {
		"{0:s}  Could not execute stored procedure [$SqladminDb].[sqladmin].[database_all_by_ssdb_not_active-set] on '$SqladminSsdb'." -f $([System.DateTime]::Now)
		"`tException Message = `"$($_.Exception.Message)`"."
		"EXECUTE [sqladmin].[database_all_by_ssdb_not_active-set]"
		"`t@computer_name = N'$ComputerName',"
		"`t@ssdb_name = N'$SsdbName';"
		return
	}
	$cmdSqladmin = $null
	$cnnSqladmin.Close()
	$cnnSqladmin = $null
	if ($rc -ne -1) { "{0:s}  Update on '$SsdbName_Full' (databases is_active = FALSE) failed. Return value = '$rc'." -f $([System.DateTime]::Now) | Write-Output }
	else { "{0:s}  '$SsdbName_Full' updated (databases is_active = FALSE) with success." -f $([System.DateTime]::Now) | Write-Output }#>

	# Get databases with data
	$smoServer = New-Object Microsoft.SqlServer.Management.Smo.Server $SsdbName_Full
	$smoServer.ConnectionContext.StatementTimeout = 6
	$smoServer.ConnectionContext.ConnectTimeout = 10
	try { $smoServer.Databases | Out-Null }  # Check connection
	catch{
		"{0:s}Z  '$SsdbName_Full' is not available. Data collection is not done." -f $([System.DateTime]::UtcNow) | Write-Output
		return
	}
	$smoServer.Databases | ForEach-Object {	
		[string]$dbName = $_.Name
		[string]$dbCollation = $_.Collation
		[Int]$dbCompabilitylevel = [Int]$_.CompatibilityLevel
		[string]$dbRecoveryModel = $_.RecoveryModel.ToString()
		[string]$dbOwner = $_.Owner
		if ($_.LastBackupDate -eq 0)
        { $dbBackupFullLast = $null }
		else
        { $dbBackupFullLast = $_.LastBackupDate }
		if ($_.LastDifferentialBackupDate -eq 0)
        { $dbBackupDiffLast = $null }
		else
        { $dbBackupDiffLast = $_.LastDifferentialBackupDate }
		if ($_.LastLogBackupDate -eq 0)
        { $dbBackupLogLast = $null }
		else
        { $dbBackupLogLast = $_.LastLogBackupDate }
		$dbCreateTime = $_.CreateDate
		$dbCreatePerson = $null
		[string]$dbPageverify = $_.PageVerify.ToString()
		[string]$dbStatus = $_.Status.ToString()
		$dbIsActive = $null
		$dbIsEncrypted = $null
		$dbIsReadonly = $_.ReadOnly
		$dbIsHomemade = $null
		$dbIsAutoclose = $_.AutoClose
		$dbIsAutoShrink = $_.AutoShrink
		$dbIsBrokerenabled = $_.BrokerEnabled
		$dbDescription = $null
		
		[string]$strSqladmin = "Data Source=$SqladminSsdb;Integrated Security=SSPI;Initial Catalog=$SqladminDb;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"
		$cnnSqladmin = New-Object System.Data.SqlClient.SqlConnection $strSqladmin
		try { $cnnSqladmin.Open() }
		catch { throw $_ }
		$cmdSqladmin = New-Object System.Data.SqlClient.SqlCommand '[sqladmin].[database-set]', $cnnSqlAdmin
		$cmdSqladmin.CommandType = [System.Data.CommandType]::StoredProcedure
		$cmdSqladmin.Parameters.Add('@computer_name', $ComputerName) | Out-Null
		$cmdSqladmin.Parameters.Add('@ssdb_name', $SsdbName) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_name', $dbName) | Out-Null
		$cmdSqladmin.Parameters.Add('@collation_name', $dbCollation) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_compabilitylevel', $dbCompabilitylevel) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_recovery_model', $dbRecoveryModel) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_owner', $dbOwner) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_backup_full_last', $dbBackupFullLast) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_backup_diff_last', $dbBackupDiffLast) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_backup_log_last', $dbBackupLogLast) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_create_time', $dbCreateTime) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_create_person', $dbCreatePerson) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_pageverify', $dbPageVerify) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_status', $dbStatus) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_is_active', $dbIsActive) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_is_encrypted', $dbIsEncrypted) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_is_readonly', $dbIsReadonly) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_is_homemade', $dbIsHomemade) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_is_autoclose', $dbIsAutoclose) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_is_autoshrink', $dbIsAutoshrink) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_is_brokerenabled', $dbIsBrokerenabled) | Out-Null
		$cmdSqladmin.Parameters.Add('@database_description', $dbDescription) | Out-Null
        [string]$DynamicSql = @"
EXECUTE [sqladmin].[database-set]
  @computer_name = N'$ComputerName',
  @ssdb_name = N'$SsdbName',
  @database_name = N'$dbName',
  @collation_name = N'$dbCollation',
  @database_compabilitylevel = $dbCompabilitylevel,
  @database_recovery_model = N'$dbRecoveryModel',
  @database_owner = N'$dbOwner',
  @database_backup_full_last = $dbBackupFullLast,
  @database_backup_diff_last = $dbBackupDiffLast,
  @database_backup_log_last = $dbBackupLogLast,
  @database_create_time = $dbCreateTime,
  @database_create_person = N'$dbCreatePerson',
  @database_pageverify = N'$dbPageVerify',
  @database_status = N'$dbStatus',
  @database_is_active = $dbIsActive,
  @database_is_encrypted = $dbIsEncrypted,
  @database_is_readonly = $dbIsReadonly,
  @database_is_homemade = $dbIsHomemade,
  @database_is_autoclose = $dbIsAutoclose,
  @database_is_autoshrink = $dbIsAutoshrink,
  @database_is_brokerenabled = $dbIsBrokerenabled,
  @database_description = N'$dbDescription';
"@
        $DynamicSql | Write-Debug
		try { $rc = $cmdSqladmin.ExecuteNonQuery() }
		catch {
			"{0:s}Z  Could not execute stored procedure [$SqladminDb].[sqladmin].[database-set] on `"$SqladminSsdb`"." -f $([System.DateTime]::UtcNow)
			"`tException Message = `"$($_.Exception.Message)`"."
		}
		$cmdSqladmin = $null
		$cnnSqladmin.Close()
		$cnnSqladmin = $null
		if ($rc -ne -1) { "{0:s}Z  Update on '$SsdbName_Full.[$dbName]' failed. Return value = '$rc'." -f $([System.DateTime]::UtcNow) | Write-Output }
		else { "{0:s}Z  '$SsdbName_Full.[$dbName]' updated with success." -f $([System.DateTime]::UtcNow) | Write-Verbose }

	}
	$smoServer = $null
}

End {}
}  # Set-Database()

function Get-Database {  # Read-SqlAdminSsdbDatabase
<#
.DESCRIPTION
  Get database information from SQLAdmin Inventory.
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  <link to external reference or documentation>
.NOTES
  ??? (Niels Grove-Rasmussen) Function created.
#>
[CmdletBinding()]
[OutputType([void])]
param ()

Begin {
    "{0:s}Z  Get-Database()" -f $([System.DateTime]::UtcNow) | Write-Verbose
}

Process {
	$cnnSqladmin = New-Object System.Data.SqlClient.SqlConnection
	$cnnSqladmin.ConnectionString = "Server=$SqladminSsdb;Integrated Security=SSPI;Database=$SqladminDb;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"
	$dml = 'SELECT [computer_name],[ssdb_name],[ssdb_version_major],[database_name] FROM [sqladmin].[v_database];'
	$ds = New-Object System.Data.DataSet

	try { $cnnSqladmin.Open() }
	catch { throw $_ }
	$da = New-Object System.Data.SqlClient.SqlDataAdapter $dml, $cnnSqladmin
	$rc = $da.Fill($ds)
	$cnnSqladmin.Close()
	$cnnSqladmin = $null
	
	$ds.Tables[0]
}

End {}
}  # Get-Database()

#endregion Database


#region Database history

function Import-DbHistory {
<#
#>
[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)]
    [string]$ComputerName,

	[Parameter(Mandatory=$true)]
    [string]$SsdbName,

    [Parameter(Mandatory=$true)]
    [Int]$SsdbVersionMajor,

	[Parameter(Mandatory=$true)]
    [string]$DbName
)
Begin {
    "{0:s}Z  Import-DbHistory('$ComputerName', '$SsdbName', $SsdbVersionMajor, '$DbName' )" -f $([System.DateTime]::UtcNow) | Write-Verbose
}

Process {
	if ($SsdbName -eq '.') { $SsdbName_Full = $ComputerName }
	else { $SsdbName_Full = $ComputerName + '\' + $SsdbName }
	"{0:s}Z  Updating details on `"$SsdbName_Full.[$DbName]`"..." -f $([System.DateTime]::UtcNow)
	
	# Get data
	$smoServer = New-Object Microsoft.SqlServer.Management.Smo.Server $SsdbName_Full
	$smoServer.ConnectionContext.StatementTimeout = 6
	$smoServer.ConnectionContext.ConnectTimeout = 10
	$smoDb = $smoServer.Databases[$DbName]
	try { $DataSpace = $smoDb.DataSpaceUsage }
    catch {
        "{0:s}  WARNING: NULL value recieved. History data is not registered on this database." -f $([System.DateTime]::Now) | Write-Output
		return $null
    }
	$IndexSpace = $smoDb.IndexSpaceUsage
	$Size = [int]($smoDb.Size * 1024)  # MB -> KB. Source is type double.
	$FreeSpace = [int]$smoDb.SpaceAvailable  # Source is type double

	$smoServer = $null
	if ($DataSpace -eq $null) {
		"{0:s}  WARNING: NULL value recieved. History data is not registered on this database." -f $([System.DateTime]::Now) | Write-Output
		return $null
	}
	
	try { $VlfCount = Get-VlfCount -ComputerName $ComputerName -SsdbName $SsdbName -SsdbVersionMajor $SsdbVersionMajor -DbName $DbName }
	catch { $VlfCount = $null }
	"`n`tData Space  = $DataSpace KB`n`tIndex Space = $IndexSpace KB`n`tSize        = $Size KB`n`tFree Space  = $FreeSpace KB`n`tVLF Count   = $VlfCount" | Write-Verbose
	
	# Insert data into SQLAdmin repository
	$cnn = New-Object System.Data.SqlClient.SqlConnection
	$cnn.ConnectionString = "Server=$SqladminSsdb;Integrated Security=SSPI;Database=$SqladminDb;Application Name=$($MyInvocation.MyCommand.Name)"
	$cmd = New-Object System.Data.SqlClient.SqlCommand '[sqladmin].[database_history-set]', $cnn
	$cmd.CommandType = [System.Data.CommandType]::StoredProcedure

	$cnn.Open()
	$cmd.Parameters.Add('@computer_name', [System.Data.SqlDbType]::NVarChar, 128).Value = $ComputerName
	$cmd.Parameters.Add('@ssdb_name', [System.Data.SqlDbType]::NVarChar, 128).Value = $SsdbName
	$cmd.Parameters.Add('@database_name', [System.Data.SqlDbType]::NVarChar, 128).Value = $DbName
	$cmd.Parameters.Add('@dataspace_in_kb', [System.Data.SqlDbType]::Int).Value = $DataSpace
	$cmd.Parameters.Add('@indexspace_in_kb', [System.Data.SqlDbType]::Int).Value = $IndexSpace
	$cmd.Parameters.Add('@size_in_kb', [System.Data.SqlDbType]::Int).Value = $Size
	$cmd.Parameters.Add('@freespace_in_kb', [System.Data.SqlDbType]::Int).Value = $FreeSpace
	$cmd.Parameters.Add('@vlf_count', [System.Data.SqlDbType]::Int).Value = $VlfCount
	
	try {$rc = $cmd.ExecuteNonQuery() }
	catch { throw $_ }
	$cnn.Close()
	
	$cmd = $null
	$cnn = $null
}

END {}
}  # Import-DbHistory()

function Get-VlfCount {
<#
#>
[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)]
    [string]$ComputerName,

	[Parameter(Mandatory=$true)]
    [string]$SsdbName,

    [Parameter(Mandatory=$true)]
    [Int]$SsdbVersionMajor,

	[Parameter(Mandatory=$true)]
    [string]$DbName
)

Begin {
    "{0:s}Z  Get-VlfCount('$ComputerName', '$SsdbName', '$SsdbVersionMajor', '$DbName')" -f $([System.DateTime]::UtcNow) | Write-Verbose
}

Process {
    if ($SsdbVersionMajor -le 10) {
$SqlDdl = @"
SET NOCOUNT ON;
CREATE TABLE #stage(
 [file_id] INT
 ,[file_size] BIGINT
 ,[start_offset] BIGINT
 ,[f_seq_no] BIGINT
 ,[status] BIGINT
 ,[parity] BIGINT
 ,[create_lsn] NUMERIC(38)
);
INSERT INTO #stage EXECUTE (N'DBCC LogInfo WITH no_infomsgs');
SELECT COUNT(1) FROM #stage;
DROP TABLE #stage;
"@
    }
    else {
$SqlDdl = @"
SET NOCOUNT ON;
CREATE TABLE #stage(
  [recovery_unit_id] INT
 ,[file_id] INT
 ,[file_size] BIGINT
 ,[start_offset] BIGINT
 ,[f_seq_no] BIGINT
 ,[status] BIGINT
 ,[parity] BIGINT
 ,[create_lsn] NUMERIC(38)
);
INSERT INTO #stage EXECUTE (N'DBCC LogInfo WITH no_infomsgs');
SELECT COUNT(1) FROM #stage;
DROP TABLE #stage;
"@
    }

	if ($SsdbName -eq '.') { $SsdbName_Full = $ComputerName }
	else { $SsdbName_Full = $ComputerName + '\' + $SsdbName }

	$cnnSqladmin = New-Object System.Data.SqlClient.SqlConnection
	$cnnSqladmin.ConnectionString = "Server=$SsdbName_Full;Integrated Security=SSPI;Database=$DbName;Application Name=$($MyInvocation.MyCommand.Name);Connection Timeout=3"
	$ds = New-Object System.Data.DataSet

	try { $cnnSqladmin.Open() }
	catch { throw $_ }
	$da = New-Object System.Data.SqlClient.SqlDataAdapter $SqlDdl, $cnnSqladmin
	$rc = $da.Fill($ds)
	$cnnSqladmin.Close()
	$cnnSqladmin = $null
	
	[Int]$VlfCount = $ds.Tables[0].Rows[0].Column1
    "VLF Count = $VlfCount" | Write-Debug
    $VlfCount
}

End {}
}  # Get-VlfCount()

#endregion Database history


#region Job

#endregion Job
