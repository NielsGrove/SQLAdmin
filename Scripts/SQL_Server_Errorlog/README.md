# SQL Server Errorlog

## Description

The content of the SQL Server Errorlog i a mixture of both technical error messages and audit messages at very different levels.

## Path

There are several ways to the path of the SQL Server errorlog files.

- Facet: ErrorLogPath
- Startup parameter: -e
  - SQL Server Configuration Manager
  - Windows Registry: HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\<Instance path...>
- T-SQL: `SERVERPROPERTY('ErrorLogFileName')`
- T-SQL: `xp_readerrorlog 0,1, N'Logging SQL Server messages in file', NULL,NULL, N'asc'`
- SMO: `Server`Class: [`ErrorLogPath`]() Property
- Windows Windows Event Viewer: Application Log > Event ID 17111
- dbatools: `Get-DbaErrorLogConfig`

### Links

- [Identify location of the SQL Server Error Log file](https://www.mssqltips.com/sqlservertip/2506/identify-location-of-the-sql-server-error-log-file/)
- [How to find the location of the Sql Server Error Log File](https://sqlhints.com/2016/10/01/how-to-find-the-location-of-the-sql-server-error-log-file/)

## Content

`xp_readerrorlog`

`sp_readerrorlog`

### Links

- [Reading large text files with Powershell](http://www.happysysadm.com/2014/10/reading-large-text-files-with-powershell.html)
- [How can I make this PowerShell script parse large files faster?](http://stackoverflow.com/questions/9439210/how-can-i-make-this-powershell-script-parse-large-files-faster)
