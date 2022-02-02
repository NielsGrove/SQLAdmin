<#
.DESCRIPTION
  Example on using COUNT() to implement test of extance
#>

#Requires -Version 7

$DbName = 'SSISDB'

$SqlInstanceName = '(local)\MSSQL2019'
$CnnStr = "Server=$SqlInstanceName;Integrated Security=SSPI"
$SqlStatement = 'SELECT COUNT(*) AS [db_count] FROM [master].[sys].[databases] WHERE [name]=@dbname;'
$SqlParameters = '@dbname sysname'

$CnnSql = New-Object System.Data.SqlClient.SqlConnection
$CnnSql.ConnectionString = $CnnStr
$CnnSql.Open()

$CmdSql = New-Object System.Data.SqlClient.SqlCommand
$CmdSql.Connection = $CnnSql
$CmdSql.CommandText = '[master].[sys].[sp_executesql]'
$CmdSql.CommandType = [System.Data.CommandType]::StoredProcedure
$CmdSql.Parameters.Add('@stmt', [System.Data.SqlDbType]::NVarChar, -1).Value = $SqlStatement
$CmdSql.Parameters.Add('@params', [System.Data.SqlDbType]::NVarChar, 500).Value = $SqlParameters
$CmdSql.Parameters.Add('@dbname', [System.Data.SqlDbType]::NVarChar, 128).Value = $DbName
$Rdr = $CmdSql.ExecuteReader()
while ($Rdr.Read()) { $DbCount = $Rdr['db_count'] }
$Rdr.Close()
$CnnSql.Close()

"Db Count: $DbCount"

