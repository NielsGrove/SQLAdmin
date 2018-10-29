/*
Description
  Installation info on SQL Server Database Engine installation

Reference
  StackExchange: Determining the Actual Server Create Date
  (https://dba.stackexchange.com/questions/73817/determining-the-actual-server-create-date)
*/

SELECT SERVERPROPERTY ('MachineName') AS PhysicalMachineName,
  SERVERPROPERTY ('ServerName') AS SQLServerName,
  SERVERPROPERTY ('Edition') AS ServerEdition,
  CAST(SUBSTRING(@@Version,charindex('SQL',@@version, 1),15) AS VARCHAR(255)) +  ' + ' 
    + CAST (SERVERPROPERTY ('productlevel')AS VARCHAR (50)) + ' + (Build'
    + CAST (SERVERPROPERTY ('ProductVersion') AS VARCHAR (50)) +')' AS ProductVersion,
  RIGHT(@@version, (Len(@@Version)-charindex('Windows',@@version, 1))+1) AS [O.S.],
  SERVERPROPERTY ('Collation') AS Collation,
  create_date as 'SQL Server Installation Date'
FROM sys.server_principals 
WHERE name='NT AUTHORITY\SYSTEM'
