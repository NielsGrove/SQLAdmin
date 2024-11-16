# CheckDB

Run SQL Server DBCC CHECKDB in PowerShell Advanced Function. All original parameters are baked in the solution.

The functionality of the original DBCC [CHECKDB](https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-checkdb-transact-sql) command is implemented as PowerShell functionality with full coverage. The execution will collect all messages.

Also some scripts using the function in tests and examples. The AdventureWorks database is used for this.

Error messages are converted to and handled as PowerShell Errors ([ErrorRecord](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.errorrecord)).

The structure of the PowerShell module is inspired by the structure of [dbatool.io](https://dbatools.io/) modules.
