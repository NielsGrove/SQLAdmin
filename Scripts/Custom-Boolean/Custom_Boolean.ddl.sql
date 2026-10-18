/*
Description
    Create database and objects to work with Custom Boolean columns.
*/
USE [tempdb];
GO

EXECUTE master.dbo.xp_create_subdir 'S:\MSSQL16.SSDB2022\Data\';
GO
CREATE DATABASE [custom_bool]
ON  PRIMARY ( NAME = N'custom_bool_data0', FILENAME = N'S:\MSSQL16.SSDB2022\Data\custom_bool_data0.mdf', SIZE = 48MB , FILEGROWTH = 64MB ),
	(NAME = N'custom_bool_data1', FILENAME = N'S:\MSSQL16.SSDB2022\Data\custom_bool_data1.ndf', SIZE = 48MB , FILEGROWTH = 64MB ),
	(NAME = N'custom_bool_data2', FILENAME = N'S:\MSSQL16.SSDB2022\Data\custom_bool_data2.ndf', SIZE = 48MB , FILEGROWTH = 64MB ),
	(NAME = N'custom_bool_data3', FILENAME = N'S:\MSSQL16.SSDB2022\Data\custom_bool_data3.ndf', SIZE = 48MB , FILEGROWTH = 64MB ),
	(NAME = N'custom_bool_data4', FILENAME = N'S:\MSSQL16.SSDB2022\Data\custom_bool_data4.ndf', SIZE = 48MB , FILEGROWTH = 64MB ),
	(NAME = N'custom_bool_data5', FILENAME = N'S:\MSSQL16.SSDB2022\Data\custom_bool_data5.ndf', SIZE = 48MB , FILEGROWTH = 64MB ),
	(NAME = N'custom_bool_data6', FILENAME = N'S:\MSSQL16.SSDB2022\Data\custom_bool_data6.ndf', SIZE = 48MB , FILEGROWTH = 64MB ),
	(NAME = N'custom_bool_data7', FILENAME = N'S:\MSSQL16.SSDB2022\Data\custom_bool_data7.ndf', SIZE = 48MB , FILEGROWTH = 64MB )
LOG ON ( NAME = N'custom_bool_log', FILENAME = N'S:\MSSQL16.SSDB2022\Data\custom_bool_log.ldf', SIZE = 768MB , FILEGROWTH = 64MB );
GO
ALTER DATABASE [custom_bool] SET RECOVERY SIMPLE WITH NO_WAIT;
GO
ALTER AUTHORIZATION ON DATABASE::[custom_bool] TO [sa];
GO

EXECUTE [custom_bool].[sys].[sp_addextendedproperty]
	@name=N'MS_Description', 
	@value=N'Custom Boolean sandbox';
GO


/**  2) Table for simple fixed but nullable Custom Boolean  **/
USE [custom_bool];
GO
CREATE TABLE [custom_bool].[dbo].[fixed_test]
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
ALTER TABLE [custom_bool].[dbo].[fixed_test]  WITH CHECK ADD  CONSTRAINT [CK_col_00] CHECK  
	(([col_00]='yes' OR [col_00]='y' OR [col_00]='no' OR [col_00]='n'));
ALTER TABLE [dbo].[fixed_test] CHECK CONSTRAINT [CK_col_00];
GO
EXECUTE [custom_bool].sys.sp_addextendedproperty
	@name=N'MS_Description',
	@value=N'Custom Boolean table with simple columns.',
	@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'fixed_test';
GO
USE [tempdb];
GO


/**  Table for Unicode fixed Custom Boolean  **/
CREATE TABLE [custom_bool].[dbo].[nfixed_test]
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
USE [custom_bool];
GO
ALTER TABLE [custom_bool].[dbo].[nfixed_test]  WITH CHECK ADD  CONSTRAINT [CK_col_00] CHECK  
	(([col_00]='yes' OR [col_00]='y' OR [col_00]='no' OR [col_00]='n'));
ALTER TABLE [dbo].[fixed_test] CHECK CONSTRAINT [CK_col_00];
GO
USE [tempdb];
GO


/**  Table for variable Custom Boolean  **/
CREATE TABLE [custom_bool].[dbo].[var_test]
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
CREATE TABLE [custom_bool].[dbo].[nvar_test]
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
CREATE TABLE [custom_bool].[dbo].[types]
(
	[type_id] int IDENTITY(1, 1) NOT NULL,
	[type_value] char(5) NOT NULL,
    CONSTRAINT [pk_types] PRIMARY KEY ([type_id])
);
GO
INSERT INTO [custom_bool].[dbo].[types] ([type_value])
VALUES
    ('true'),
    ('false');
GO
--SELECT * FROM [dbo].[types];
CREATE TABLE [custom_bool].[dbo].[type_test]
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
