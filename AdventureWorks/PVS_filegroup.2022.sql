/*
Description
  Move PVS to own filegroup.

  See more in SQLAdmin post: 
*/
USE [tempdb];
GO

ALTER DATABASE [AdventureWorks] SET ACCELERATED_DATABASE_RECOVERY = OFF;
GO

EXECUTE [master].[sys].[sp_persistent_version_cleanup]
    @dbname = N'AdventureWorks';
GO
SELECT
    [databases].[name] AS [database_name],
    [persistent_version_store_size_kb]
FROM [sys].[dm_tran_persistent_version_store_stats]
INNER JOIN [master].[sys].[databases] ON [databases].[database_id] = [dm_tran_persistent_version_store_stats].[database_id]
WHERE [databases].[name] = N'AdventureWorks';
GO
/*  When [persistent_version_store_size_kb] is 0 (zero) you can move on.   */

/* This part creating the actual filegroup is not in the Microsoft documentation. */
ALTER DATABASE [AdventureWorks] ADD FILEGROUP [VERSIONSTORE];
GO
ALTER DATABASE [AdventureWorks] ADD FILE 
    ( NAME = N'AdventureWorks_vs_0', FILENAME = N'L:\SSDB2022\Data\AdventureWorks_vs_0.mdf' , SIZE = 8MB , FILEGROWTH = 64MB ) 
    TO FILEGROUP [VERSIONSTORE];
ALTER DATABASE [AdventureWorks] ADD FILE 
    ( NAME = N'AdventureWorks_vs_1', FILENAME = N'L:\SSDB2022\Data\AdventureWorks_vs_1.ndf' , SIZE = 8MB , FILEGROWTH = 64MB ) 
    TO FILEGROUP [VERSIONSTORE];
ALTER DATABASE [AdventureWorks] ADD FILE 
    ( NAME = N'AdventureWorks_vs_2', FILENAME = N'L:\SSDB2022\Data\AdventureWorks_vs_2.ndf' , SIZE = 8MB , FILEGROWTH = 64MB ) 
    TO FILEGROUP [VERSIONSTORE];
ALTER DATABASE [AdventureWorks] ADD FILE 
    ( NAME = N'AdventureWorks_vs_3', FILENAME = N'L:\SSDB2022\Data\AdventureWorks_vs_3.ndf' , SIZE = 8MB , FILEGROWTH = 64MB ) 
    TO FILEGROUP [VERSIONSTORE];
ALTER DATABASE [AdventureWorks] ADD FILE 
    ( NAME = N'AdventureWorks_vs_4', FILENAME = N'L:\SSDB2022\Data\AdventureWorks_vs_4.ndf' , SIZE = 8MB , FILEGROWTH = 64MB ) 
    TO FILEGROUP [VERSIONSTORE];
ALTER DATABASE [AdventureWorks] ADD FILE 
    ( NAME = N'AdventureWorks_vs_5', FILENAME = N'L:\SSDB2022\Data\AdventureWorks_vs_5.ndf' , SIZE = 8MB , FILEGROWTH = 64MB ) 
    TO FILEGROUP [VERSIONSTORE];
ALTER DATABASE [AdventureWorks] ADD FILE 
    ( NAME = N'AdventureWorks_vs_6', FILENAME = N'L:\SSDB2022\Data\AdventureWorks_vs_6.ndf' , SIZE = 8MB , FILEGROWTH = 64MB ) 
    TO FILEGROUP [VERSIONSTORE];
ALTER DATABASE [AdventureWorks] ADD FILE 
    ( NAME = N'AdventureWorks_vs_7', FILENAME = N'L:\SSDB2022\Data\AdventureWorks_vs_7.ndf' , SIZE = 8MB , FILEGROWTH = 64MB ) 
    TO FILEGROUP [VERSIONSTORE];
GO
ALTER DATABASE [AdventureWorks]
    SET ACCELERATED_DATABASE_RECOVERY = ON
    (PERSISTENT_VERSION_STORE_FILEGROUP = [VERSIONSTORE]);
GO
