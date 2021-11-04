<#
.DESCRIPTION
  Examples on using PowerShell to handle SQL Server Central Management Server.
#>

#region SMO

function Invoke-SmoExample {
  throw 'SMO example is under construction!'

  $CentralManagementServer = '(local)\MSSQL2019'

  $ServerGroupName = '0 - Production'
  $ServerGroup = New-Object -TypeName Microsoft.SqlServer.Management.RegisteredServers.ServerGroup($ServerGroupName)
  $NewServerName = 'SQLDB0042.sqladmin.lan'

  $NewServer = New-Object -TypeName Microsoft.SqlServer.Management.RegisteredServers.RegisteredServer($ServerGroup, $NewServerName)
  # ... Go to dbatools for a more usable solution
}

#endregion SMO


#region SQLServer module

function Invoke-SQLServerExample {
  throw 'SQLServer module example is under construction!'

  # Provider - SQLServer:\SqlRegistration\Database Engine Server Group ?
}

#endregion SQLServer module


#region dbatools

function Invoke-dbatoolsExample {
  throw 'dbatools example is under construction!'

  Get-DbaRegServer -SqlInstance 

  # (https://docs.dbatools.io/Add-DbaRegServer)
  # - (https://github.com/sqlcollaborative/dbatools/blob/development/functions/Add-DbaRegServer.ps1)
  Add-DbaRegServer -ServerName $NewServerName
}

#endregion dbatools


### Invoke ###

#Invoke-SmoExample
#Invoke-SQLServerExample
Invoke-dbatoolsExample
