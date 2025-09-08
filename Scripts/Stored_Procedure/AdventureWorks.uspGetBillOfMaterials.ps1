<#
.DESCRIPTION

#>

#Requires -Version 7

[string]$CnnStr = 'Data Source=(local)\SSDB2019;Integrated Security=SSPI;Initial Catalog=AdventureWorks'

$[int]_StartProductID = 42
$[DateTime]_CheckDate = '2018-06-17'

$CnnSql = New-Object Microsoft.Data.SqlClient.SqlConnection
$CnnSql.ConnectionString = $CnnStr
$CnnSql.Open()

$CmdSql = New-Object Microsoft.Data.SqlClient.SqlCommand
$CmdSql.Connection = $CnnSql
$CmdSql.CommandText = '[dbo].[uspGetBillOfMaterials]'
$CmdSql.CommandType = [Microsoft.Data.CommandType]::StoredProcedure
$CmdSql.Parameters.Add('@stmt', [Microsoft.Data.SqlDbType]::Int).Value = $SqlStatement
$CmdSql.Parameters.Add('@params', [Microsoft.Data.SqlDbType]::DateTime).Value = $SqlParameters
$Rdr = $CmdSql.ExecuteReader()
while ($Rdr.Read()) { $DbCount = $Rdr['db_count'] }
$Rdr.Close()
$CnnSql.Close()
