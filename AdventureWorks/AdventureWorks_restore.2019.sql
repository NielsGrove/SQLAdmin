/*
Description
    Restore AdventureWorks sample database on SQL Server.

Preparation
    Copy backup file from SOFTWARE-share to local backup folder.

Download
    From Microsoft SQL Server samples.
    https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms
*/

-- Get what files are in the backup set
RESTORE FILELISTONLY FROM  DISK = N'L:\SSDB2019\Backup\AdventureWorks2019.bak';

-- Get header info from backup set
RESTORE HEADERONLY FROM  DISK = N'L:\SSDB2019\Backup\AdventureWorks2019.bak';
GO


USE [master];
RESTORE DATABASE [AdventureWorks] FROM  DISK = N'L:\SSDB2019\BACKUP\AdventureWorks2019.bak' WITH
  MOVE N'AdventureWorks2019' TO N'L:\SSDB2019\Data\AdventureWorks.mdf',
  MOVE N'AdventureWorks2019_log' TO N'L:\SSDB2019\TransLog\AdventureWorks_log.ldf',
  NORECOVERY, STATS = 5;
GO
RESTORE DATABASE [AdventureWorks] WITH RECOVERY;
GO

ALTER DATABASE [AdventureWorks] SET COMPATIBILITY_LEVEL = 150;
ALTER AUTHORIZATION ON DATABASE::[AdventureWorks] TO [sa];
GO

ALTER DATABASE [AdventureWorks] MODIFY FILE (NAME=N'AdventureWorks2019', NEWNAME=N'AdventureWorks');
ALTER DATABASE [AdventureWorks] MODIFY FILE (NAME=N'AdventureWorks2019_log', NEWNAME=N'AdventureWorks_log');
GO

EXECUTE [AdventureWorks].sys.sp_updateextendedproperty
  @name=N'MS_Description',
  @value=N'AdventureWorks Sample OLTP Database' ;
GO

-- Option
ALTER DATABASE [AdventureWorks] SET QUERY_STORE = ON;
ALTER DATABASE [AdventureWorks] SET QUERY_STORE (OPERATION_MODE = READ_WRITE);
GO
