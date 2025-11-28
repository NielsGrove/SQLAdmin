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

RAISERROR(N'Check if WideWorldImporters database exists...', 0,0) WITH NOWAIT;
IF EXISTS( SELECT 1 FROM [master].[sys].[databases] WHERE [name] = N'WideWorldImporters' )
	RAISERROR(N'ERROR - The WideWorldImporters database exists!!!', 20,0) WITH LOG;
ELSE
	RAISERROR(N'OK - The database does not exist.', 0,0) WITH NOWAIT;
GO
/*** Cleanup existing WideWorldImporters database  ***
ALTER DATABASE [WideWorldImporters] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE [WideWorldImporters];
DROP LOGIN [WWI_owner];
--***/
-- Restore database
-- NB! Update paths before restore.
--USE [master];
RAISERROR(N'Restore WideWorldImporters database...', 0,0) WITH NOWAIT;
RESTORE DATABASE [WideWorldImporters] FROM  DISK = N'S:\MSSQL17.SSDB2025\MSSQL\Backup\WideWorldImporters-Full.bak' WITH
    MOVE N'WWI_Primary' TO N'S:\MSSQL17.SSDB2025\MSSQL\Data\WideWorldImporters.mdf',
    MOVE N'WWI_UserData' TO N'S:\MSSQL17.SSDB2025\MSSQL\Data\WideWorldImporters_UserData.ndf',
    MOVE N'WWI_InMemory_Data_1' TO N'S:\MSSQL17.SSDB2025\MSSQL\Data\WideWorldImporters_InMemory_Data_1',
    MOVE N'WWI_Log' TO N'S:\MSSQL17.SSDB2025\MSSQL\TransLog\WideWorldImporters.ldf',
    NORECOVERY, STATS = 5;
GO
RESTORE DATABASE [WideWorldImporters] WITH RECOVERY;
GO

RAISERROR(N'Change Recovery Model to Simple...', 0,0) WITH NOWAIT;
ALTER DATABASE [WideWorldImporters] SET RECOVERY SIMPLE WITH NO_WAIT;
GO

--USE [master];
DECLARE @_dummy_owner nvarchar(128) = N'WWI_owner';
IF EXISTS( SELECT 1 FROM [master].[sys].[server_principals] WHERE [name] = @_dummy_owner )
BEGIN
    RAISERROR(N'OK - Dummy owner exists.', 0,0) WITH NOWAIT;
END
ELSE
BEGIN
	RAISERROR(N'Creating dummy owner...', 0,0) WITH NOWAIT;
	DECLARE @_stmt0 AS nvarchar(4000) =
		N'CREATE LOGIN [' +
		@_dummy_owner +
		N'] WITH PASSWORD=N''' + 
		CAST( NEWID() AS nvarchar(256) ) +
		N''', DEFAULT_DATABASE=[tempdb], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;';
	EXECUTE [master].[dbo].[sp_executesql] @stmt = @_stmt0;
 
	DECLARE @_stmt1 AS nvarchar(4000) =
		N'ALTER LOGIN [' +
		@_dummy_owner +
		N'] DISABLE;';
	EXECUTE [master].[dbo].[sp_executesql] @stmt = @_stmt1;

	DECLARE @_stmt2 AS nvarchar(4000) =
		N'DENY CONNECT SQL TO [' +
		@_dummy_owner +
		N'];';
	EXECUTE [master].[dbo].[sp_executesql] @stmt = @_stmt2;
END
RAISERROR(N'Set dummy owner on WideWorldImporters database...', 0,0) WITH NOWAIT;
DECLARE @_stmt3 AS nvarchar(4000) = 
	N'ALTER AUTHORIZATION ON DATABASE::[WideWorldImporters] TO [' +
	@_dummy_owner +
	N']';
EXECUTE [master].[dbo].[sp_executesql] @stmt = @_stmt3;

RAISERROR(N'Change Compatibility Level on WideWorldImporters database to instance version...', 0,0) WITH NOWAIT;
DECLARE @_comp_level AS tinyint = ( SELECT [compatibility_level] FROM [master].[sys].[databases] WHERE [name]='master' );
DECLARE @_stmt4 AS nvarchar(4000) =
	N'ALTER DATABASE [WideWorldImporters] SET COMPATIBILITY_LEVEL = ' +
	CAST( @_comp_level AS nvarchar(3)) +
	N';';
EXECUTE [master].[dbo].[sp_executesql] @stmt = @_stmt4;

RAISERROR(N'Add MS_Description to the WideWorldImporters database...', 0,0) WITH NOWAIT;
EXECUTE [WideWorldImporters].[sys].[sp_addextendedproperty]
    @name=N'MS_Description',
    @value=N'WideWorldImporters Sample OLTP Database';
GO

RAISERROR(N'Enable Query Store on the WideWorldImporters database', 0,0) WITH NOWAIT;
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE = ON;
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE (OPERATION_MODE = READ_WRITE);
GO
