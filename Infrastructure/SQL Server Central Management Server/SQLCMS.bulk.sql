/*
Description
  Add a bulk of servers to SQL CMS.

  Connect to the SQL Server Database Engine instance holding the given Central Management Server.
*/
USE [msdb];
GO

DECLARE @server_group AS int;
SELECT @server_group = server_group_id 
FROM dbo.sysmanagement_shared_server_groups 
WHERE [name]='Development';

DECLARE @new_server_id AS int;
EXECUTE dbo.sp_sysmanagement_add_shared_registered_server
  @name = N'Frodo\SSDB01',
  @server_group_id = @server_group,
  @server_name = N'Frodo.sqladmin.lan\SSDB01',
  @description = N'First database instance on Frodo.sqladmin.lan.',
  @server_type = 0,
  @server_id = @new_server_id OUTPUT;
SELECT @new_server_id AS [new_server_id];

EXECUTE dbo.sp_sysmanagement_add_shared_registered_server
  @name = N'Frodo\SSDB02',
  @server_group_id = @server_group,
  @server_name = N'Frodo.sqladmin.lan\SSDB02',
  @description = N'Second database instance on Frodo.sqladmin.lan.',
  @server_type = 0,
  @server_id = @new_server_id OUTPUT;
SELECT @new_server_id AS [new_server_id];
GO
