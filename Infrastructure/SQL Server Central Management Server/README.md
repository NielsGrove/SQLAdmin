# SQM Server Central Management Server

## Transact-SQL

The script file `SQLCMS.DML.sql` has some examples on how to interact with SQL CMS using T-SQL.

When adding multiple servers at once to SQL CMS there are some keys to handle. See example in the script file `SQLCMS.bulk.sql`.

## PowerShell

ToDo - but start by a look at dbatools.

### SMO

The .NET SMO classes for Registered Servers are in the namespace [Microsoft.SqlServer.Management.Smo.RegisteredServers](https://docs.microsoft.com/en-us/dotnet/api/microsoft.sqlserver.management.registeredservers).

These are some relevant classes:

- `RegisteredServer`
- `RegisteredServerCollection`
- `RegSvrCollectionBase`
- `RegSvrSmoObject`
- `ServerGroup`
- `ServerGroupBase`
- `ServerGroupCollection`

### SQLServer module

(TBD)

### dbatools

[Add-DbaRegServer](https://github.com/sqlcollaborative/dbatools/blob/development/functions/Add-DbaRegServer.ps1)

## Reference

SQLAdmin blog: [Central Registrered Servers](https://sqladm.blogspot.com/2009/06/central-registrered-servers.html)

dbatools: [managing central management server](https://dbatools.io/cms/)

Manning: [Learn dbatools in a Month of Lunches](https://www.manning.com/books/learn-dbatools-in-a-month-of-lunches)  
*Still in Manning Early Access Program (MEAP), but looks quite promising.*

Microsoft Docs: [Administer multiple servers using Central Management Servers](https://docs.microsoft.com/en-us/sql/relational-databases/administer-multiple-servers-using-central-management-servers)

Arco Scheepen (SQLServerCentral): [Managing Registered servers with SQL Powershell](https://www.sqlservercentral.com/articles/managing-registered-servers-with-sql-powershell)
