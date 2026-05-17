/*
Description
	Cleanup sandbox database for Custom Boolean.
*/
USE [custom_bool];
GO

ALTER TABLE [dbo].[fixed_test] DROP CONSTRAINT [CK_col_00];
TRUNCATE TABLE [custom_bool].[dbo].[fixed_test];
DROP TABLE [custom_bool].[dbo].[fixed_test];

DROP TABLE [custom_bool].[dbo].[nfixed_test];

DROP TABLE [custom_bool].[dbo].[var_test];

DROP TABLE [custom_bool].[dbo].[nvar_test];

DROP TABLE [custom_bool].[dbo].[types];
DROP TABLE [custom_bool].[dbo].[type_test];


USE [tempdb];
GO
EXECUTE [msdb].[dbo].[sp_delete_database_backuphistory] @database_name = N'custom_bool';
GO
ALTER DATABASE [custom_bool] SET  SINGLE_USER WITH NO_WAIT;
GO
DROP DATABASE [custom_bool];
GO
