/*
Description
  Restore AdventureWorks sample database on SQL Server 2022.

Preparation
  Copy backup file from SOFTWARE-share to local backup folder.

Download
  From Microsoft SQL Server samples on Github.
  https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak
*/

-- Get what files are in the backup set
RESTORE FILELISTONLY FROM  DISK = N'L:\SSDB2022\Backup\AdventureWorks2022.bak';

-- Get header info from backup set
RESTORE HEADERONLY FROM  DISK = N'L:\SSDB2022\Backup\AdventureWorks2022.bak';
GO

-- Restore database
-- NB! Update paths before restore.
USE [master];
RESTORE DATABASE [AdventureWorks] FROM  DISK = N'L:\SSDB2022\Backup\AdventureWorks2022.bak' WITH
  MOVE N'AdventureWorks2022' TO N'L:\SSDB2022\Data\AdventureWorks.mdf',
  MOVE N'AdventureWorks2022_log' TO N'L:\SSDB2022\TransLog\AdventureWorks_log.ldf',
  NORECOVERY, STATS = 5;
GO
RESTORE DATABASE [AdventureWorks] WITH RECOVERY;
GO

ALTER DATABASE [AdventureWorks] SET COMPATIBILITY_LEVEL = 160;
ALTER AUTHORIZATION ON DATABASE::[AdventureWorks] TO [sa];
GO

ALTER DATABASE [AdventureWorks] MODIFY FILE (NAME=N'AdventureWorks2022', NEWNAME=N'AdventureWorks');
ALTER DATABASE [AdventureWorks] MODIFY FILE (NAME=N'AdventureWorks2022_log', NEWNAME=N'AdventureWorks_log');
GO

EXECUTE [AdventureWorks].sys.sp_updateextendedproperty
  @name=N'MS_Description',
  @value=N'AdventureWorks Sample OLTP Database' ;
GO

-- Option: Set Query Store on the database
ALTER DATABASE [AdventureWorks] SET QUERY_STORE = ON;
ALTER DATABASE [AdventureWorks] SET QUERY_STORE (OPERATION_MODE = READ_WRITE);
GO
