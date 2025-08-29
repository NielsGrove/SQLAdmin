/*
Description
    Create database and objects to work with Custom Boolean columns.
*/

CREATE DATABASE [custom_bool]
ON  PRIMARY ( NAME = N'custom_bool',
    FILENAME = N'L:\SSDB2019\Data\custom_bool.mdf',
    SIZE = 8MB , FILEGROWTH = 64MB )
LOG ON ( NAME = N'custom_bool_log',
    FILENAME = N'L:\SSDB2019\TransLog\custom_bool_log.ldf', 
    SIZE = 8MB , FILEGROWTH = 64MB );
GO

USE [custom_bool];
GO
ALTER AUTHORIZATION ON DATABASE::[custom_bool] TO [sa];
GO


/**  Table for simple fixed Custom Boolean  **/
USE [custom_bool];
GO
CREATE TABLE [dbo].[fixed_test]
(
	[col_00] char(5) NOT NULL,
	[col_01] char(5) NOT NULL,
	[col_02] char(5) NOT NULL,
	[col_03] char(5) NOT NULL,
	[col_04] char(5) NOT NULL,
	[col_05] char(5) NOT NULL,
	[col_06] char(5) NOT NULL,
	[col_07] char(5) NOT NULL,
	[col_08] char(5) NOT NULL,
	[col_09] char(5) NOT NULL,
	[col_10] char(5) NOT NULL,
	[col_11] char(5) NOT NULL,
	[col_12] char(5) NOT NULL,
	[col_13] char(5) NOT NULL,
	[col_14] char(5) NOT NULL,
	[col_15] char(5) NOT NULL
);
GO


/**  Table for Unicode fixed Custom Boolean  **/
USE [custom_bool];
GO
CREATE TABLE [dbo].[nfixed_test]
(
	[col_00] nchar(5) NOT NULL,
	[col_01] nchar(5) NOT NULL,
	[col_02] nchar(5) NOT NULL,
	[col_03] nchar(5) NOT NULL,
	[col_04] nchar(5) NOT NULL,
	[col_05] nchar(5) NOT NULL,
	[col_06] nchar(5) NOT NULL,
	[col_07] nchar(5) NOT NULL,
	[col_08] nchar(5) NOT NULL,
	[col_09] nchar(5) NOT NULL,
	[col_10] nchar(5) NOT NULL,
	[col_11] nchar(5) NOT NULL,
	[col_12] nchar(5) NOT NULL,
	[col_13] nchar(5) NOT NULL,
	[col_14] nchar(5) NOT NULL,
	[col_15] nchar(5) NOT NULL
);
GO


/**  Table for variable Custom Boolean  **/
USE [custom_bool];
GO
CREATE TABLE [dbo].[var_test]
(
	[col_00] varchar(5) NOT NULL,
	[col_01] varchar(5) NOT NULL,
	[col_02] varchar(5) NOT NULL,
	[col_03] varchar(5) NOT NULL,
	[col_04] varchar(5) NOT NULL,
	[col_05] varchar(5) NOT NULL,
	[col_06] varchar(5) NOT NULL,
	[col_07] varchar(5) NOT NULL,
	[col_08] varchar(5) NOT NULL,
	[col_09] varchar(5) NOT NULL,
	[col_10] varchar(5) NOT NULL,
	[col_11] varchar(5) NOT NULL,
	[col_12] varchar(5) NOT NULL,
	[col_13] varchar(5) NOT NULL,
	[col_14] varchar(5) NOT NULL,
	[col_15] varchar(5) NOT NULL
);
GO


/**  Table for Unicode variable Custom Boolean  **/
USE [custom_bool];
GO
CREATE TABLE [dbo].[nvar_test]
(
	[col_00] nvarchar(5) NOT NULL,
	[col_01] nvarchar(5) NOT NULL,
	[col_02] nvarchar(5) NOT NULL,
	[col_03] nvarchar(5) NOT NULL,
	[col_04] nvarchar(5) NOT NULL,
	[col_05] nvarchar(5) NOT NULL,
	[col_06] nvarchar(5) NOT NULL,
	[col_07] nvarchar(5) NOT NULL,
	[col_08] nvarchar(5) NOT NULL,
	[col_09] nvarchar(5) NOT NULL,
	[col_10] nvarchar(5) NOT NULL,
	[col_11] nvarchar(5) NOT NULL,
	[col_12] nvarchar(5) NOT NULL,
	[col_13] nvarchar(5) NOT NULL,
	[col_14] nvarchar(5) NOT NULL,
	[col_15] nvarchar(5) NOT NULL
);
GO


/**  Table for related type Custom Boolean  **/
USE [custom_bool];
GO
CREATE TABLE [dbo].[types]
(
	[type_id] int IDENTITY(1, 1) NOT NULL,
	[type_value] char(5) NOT NULL,
    CONSTRAINT [pk_types] PRIMARY KEY ([type_id])
);
GO
INSERT INTO [dbo].[types] ([type_value])
VALUES
    ('true'),
    ('false');
GO
--SELECT * FROM [dbo].[types];
CREATE TABLE [dbo].[type_test]
(
	[col_00] int NOT NULL,
	[col_01] int NOT NULL,
	[col_02] int NOT NULL,
	[col_03] int NOT NULL,
	[col_04] int NOT NULL,
	[col_05] int NOT NULL,
	[col_06] int NOT NULL,
	[col_07] int NOT NULL,
	[col_08] int NOT NULL,
	[col_09] int NOT NULL,
	[col_10] int NOT NULL,
	[col_11] int NOT NULL,
	[col_12] int NOT NULL,
	[col_13] int NOT NULL,
	[col_14] int NOT NULL,
	[col_15] int NOT NULL
);
GO


/**  Cleanup  **/
/*
USE [master];
GO
EXECUTE [msdb].[dbo].[sp_delete_database_backuphistory] @database_name = N'custom_bool';
GO
ALTER DATABASE [custom_bool] SET  SINGLE_USER WITH NO_WAIT;
GO
DROP DATABASE [custom_bool];
GO

DROP TABLE [custom_bool].[dbo].[fixed_test];

DROP TABLE [custom_bool].[dbo].[nfixed_test];

DROP TABLE [custom_bool].[dbo].[var_test];

DROP TABLE [custom_bool].[dbo].[nvar_test];

DROP TABLE [custom_bool].[dbo].[types];
DROP TABLE [custom_bool].[dbo].[type_test];
--*/
