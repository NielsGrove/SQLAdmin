/*
Description
Create basic SQLAdmin database.
Standard local database for SQL Server administration. Defined by the DBA team.
*/


/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

-- Alternative seen on some SQL 2005 installations (System database datafile path)
/*
DECLARE @data_directory NVARCHAR(255);
EXECUTE [master].[dbo].[xp_instance_regread]
  N'HKEY_LOCAL_MACHINE'
 ,N'SOFTWARE\Microsoft\Microsoft SQL Server\Setup'
 ,N'SQLDataRoot'
 ,@data_directory OUTPUT; 
PRINT N':: Data directory = "' + @data_directory + '".';

DECLARE @log_directory NVARCHAR(255);
EXECUTE [master].[dbo].[xp_instance_regread]
  N'HKEY_LOCAL_MACHINE'
 ,N'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer'
 ,N'DefaultLog'
 ,@log_directory OUTPUT;
PRINT N':: Log directory = "' + @log_directory + '".';
--*/
-- Get default datafile path
DECLARE @data_directory NVARCHAR(255);
EXECUTE [master].[dbo].[xp_instance_regread]
  N'HKEY_LOCAL_MACHINE'
 ,N'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer'
 ,N'DefaultData'
 ,@data_directory OUTPUT;
DECLARE @errmsg NVARCHAR(2047) = N':: Data directory = "' + @data_directory + '".';
RAISERROR(@errmsg,0,0) WITH NOWAIT;

-- Get default logfile path
DECLARE @log_directory NVARCHAR(255);
EXECUTE [master].[dbo].[xp_instance_regread]
  N'HKEY_LOCAL_MACHINE'
 ,N'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer'
 ,N'DefaultLog'
 ,@log_directory OUTPUT;
SET @errmsg = N':: Log directory = "' + @log_directory + '".';
RAISERROR(@errmsg,0,0) WITH NOWAIT;


-- Create database
DECLARE @sql NVARCHAR(MAX);
SET @sql = N'CREATE DATABASE [sqladmin] ON PRIMARY (
  NAME = N''sqladmin''
 ,FILENAME = ''' + @data_directory + N'\sqladmin.mdf''
 ,SIZE = 4MB
 ,MAXSIZE = UNLIMITED
 ,FILEGROWTH = 1MB )
LOG ON (
  NAME = N''sqladmin_log''
 ,FILENAME = ''' + @log_directory + N'\sqladmin.ldf''
 ,SIZE = 4MB
 ,MAXSIZE = UNLIMITED
 ,FILEGROWTH = 4MB ) 
COLLATE Latin1_General_CI_AS_KS_WS;';
PRINT N':: DDL:' + CHAR(13) + @sql;

EXECUTE (@sql);
GO
ALTER AUTHORIZATION ON DATABASE::[sqladmin] TO [sa];
GO
