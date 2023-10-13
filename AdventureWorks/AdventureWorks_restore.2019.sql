/*
Description
  Restore AdventureWorks sample database on SQL Server.

Preparation
 Copy backup file from SOFTWARE-share to local backup folder.
*/


USE [master];
RESTORE DATABASE [AdventureWorks] FROM  DISK = N'R:\BACKUP\AdventureWorks2019.bak' WITH
  MOVE N'AdventureWorks2017' TO N'R:\DATA\AdventureWorks.mdf',
  MOVE N'AdventureWorks2017_log' TO N'R:\LOGS\AdventureWorks_log.ldf',
  NORECOVERY, STATS = 5;
GO
RESTORE DATABASE [AdventureWorks] WITH RECOVERY;
GO

ALTER DATABASE [AdventureWorks] SET COMPATIBILITY_LEVEL = 150;
ALTER AUTHORIZATION ON DATABASE::[AdventureWorks] TO [sa];
GO
ALTER DATABASE [AdventureWorks] MODIFY FILE (NAME=N'AdventureWorks2017', NEWNAME=N'AdventureWorks');
ALTER DATABASE [AdventureWorks] MODIFY FILE (NAME=N'AdventureWorks2017_log', NEWNAME=N'AdventureWorks_log');
GO
EXECUTE [AdventureWorks].sys.sp_updateextendedproperty
  @name=N'MS_Description',
  @value=N'AdventureWorks Sample OLTP Database' ;
GO

-- Option
ALTER DATABASE [AdventureWorks] SET QUERY_STORE = ON;
ALTER DATABASE [AdventureWorks] SET QUERY_STORE (OPERATION_MODE = READ_WRITE);
GO
