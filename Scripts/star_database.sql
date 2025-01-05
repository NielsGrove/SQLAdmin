/*
Description
    Create star (*) database to investigate obscure naming in SQL Server custom elements.
*/
USE [tempdb];
/**  cleanup  **
DROP DATABASE [*];
*/

SELECT 
    SERVERPROPERTY ('InstanceDefaultDataPath') AS [InstanceDefaultDataPath],
    SERVERPROPERTY ('InstanceDefaultLogPath') AS [InstanceDefaultLogPath];
-- Take the full directory names and insert in the statement below.

CREATE DATABASE [*]
    ON  PRIMARY ( NAME = N'star_data', FILENAME = N'L:\SSDB2019\Data\star_data.mdf', SIZE = 8MB, FILEGROWTH = 8MB )
    LOG ON ( NAME = N'star_log', FILENAME = N'L:\SSDB2019\TransLog\star_log.ldf', SIZE = 8MB, FILEGROWTH = 8MB );
GO
ALTER AUTHORIZATION ON DATABASE::[*] TO [sa];
GO

USE [*];
GO
CREATE SCHEMA [*] AUTHORIZATION [dbo];
GO

-- DROP TABLE [*].[*];
CREATE TABLE [*].[*]
(
    [*] bigint NOT NULL IDENTITY (0, 2),
    [%] nvarchar(42) NULL,
    [<] int null,
    [>] int null
);
GO
ALTER TABLE [*].[*] ADD CONSTRAINT
    [PK_star] PRIMARY KEY CLUSTERED 
    ([*]) ON [PRIMARY];
GO

--TRUNCATE TABLE [*].[*];
USE [*];
INSERT INTO [*].[*] ([%],[<],[>])
VALUES
    (N'række0', 1000, -1000),
    (N'rÆkke1', 10, -100),
    (N'räkke2', 237, 7);
GO


USE [*];
SELECT [*] FROM [*].[*];
SELECT * FROM [*].[*];
SELECT COUNT(*) AS [**] FROM [*].[*];

SELECT * FROM [*].[*] WHERE [%] LIKE '%ä%';
SELECT * FROM [*].[*] WHERE [<]<500;
SELECT * FROM [*].[*] WHERE [>]<0;
