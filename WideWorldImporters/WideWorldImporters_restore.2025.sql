/*
Description
    Restore WorldWideImporters sample database on SQL Server 2025.

Preparation
    Copy backup file from SOFTWARE-share to local backup folder.

Download
    From Microsoft SQL Server samples on Github.
    https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak
*/
USE [tempdb];
GO

-- Get what files are in the backup set
RESTORE FILELISTONLY FROM  DISK = N'S:\MSSQL17.SSDB2025\MSSQL\Backup\WideWorldImporters-Full.bak';

-- Get header info from backup set
RESTORE HEADERONLY FROM  DISK = N'S:\MSSQL17.SSDB2025\MSSQL\Backup\WideWorldImporters-Full.bak';
GO

-- Restore database
-- NB! Update paths before restore.
USE [master];
RESTORE DATABASE [WideWorldImporters] FROM  DISK = N'S:\MSSQL17.SSDB2025\MSSQL\Backup\WideWorldImporters-Full.bak' WITH
    MOVE N'WWI_Primary' TO N'S:\MSSQL17.SSDB2025\MSSQL\Data\WideWorldImporters.mdf',
    MOVE N'WWI_UserData' TO N'S:\MSSQL17.SSDB2025\MSSQL\Data\WideWorldImporters_UserData.ndf',
    MOVE N'WWI_InMemory_Data_1' TO N'S:\MSSQL17.SSDB2025\MSSQL\Data\WideWorldImporters_InMemory_Data_1',
    MOVE N'WWI_Log' TO N'S:\MSSQL17.SSDB2025\MSSQL\TransLog\WideWorldImporters.ldf',
    NORECOVERY, STATS = 5;
GO
RESTORE DATABASE [WideWorldImporters] WITH RECOVERY;
GO

ALTER DATABASE [WideWorldImporters] SET COMPATIBILITY_LEVEL = 170;
ALTER AUTHORIZATION ON DATABASE::[WideWorldImporters] TO [sa];
GO

EXECUTE [WideWorldImporters].[sys].[sp_addextendedproperty]
    @name=N'MS_Description',
    @value=N'WideWorldImporters Sample OLTP Database' ;
GO

-- Option: Set Query Store on the database
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE = ON;
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (OPERATION_MODE = READ_WRITE);
GO
