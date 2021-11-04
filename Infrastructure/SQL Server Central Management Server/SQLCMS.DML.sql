/*
Description
  Investigate objects to Central Management Server (CMS).

  Connect to the SQL Server Database Engine instance holding the given Central Management Server.
*/
USE [msdb];
GO

/***  Tables  ***/
SELECT * FROM dbo.sysmanagement_shared_registered_servers_internal

SELECT * FROM dbo.sysmanagement_shared_server_groups_internal


/***  Views  ***/
SELECT * FROM dbo.sysmanagement_shared_registered_servers

SELECT * FROM dbo.sysmanagement_shared_server_groups


/***  Procedures  ***/
--  Verify that the default server types 0 - 4 exist in the CMS
EXECUTE dbo.sp_sysmanagement_verify_shared_server_type
  @server_type = 0;  -- int

-- Add new server group to CMS
DECLARE @_server_group_id AS int;
EXECUTE dbo.sp_sysmanagement_add_shared_server_group
  @name = N'0 : Production',  -- sysname
  @description = N'',  -- nvarchar(2048)
  @parent_id = 1,  -- int
  @server_type = 0,  -- int
  @server_group_id = @_server_group_id OUTPUT;  -- int, first = 7
SELECT @_server_group_id AS [new_server_group_id];

-- A more complete way to add server group to CMS.
DECLARE @parent_server_group AS int;
SELECT @parent_server_group = server_group_id
FROM msdb.dbo.sysmanagement_shared_server_groups
WHERE [name]='DatabaseEngineServerGroup';
DECLARE @new_server_group_id AS int;
EXECUTE msdb.dbo.sp_sysmanagement_add_shared_server_group
  @name = N'Development'
  ,@description = N'Development SQL Server database instances.'
  ,@parent_id = @parent_server_group
  ,@server_type = 0
  ,@server_group_id = @new_server_group_id OUTPUT;
SELECT @new_server_group_id AS [new_server_group];

-- Add new server registration to CMS
DECLARE @_server_id AS int;
EXECUTE dbo.sp_sysmanagement_add_shared_registered_server
  @name = N'SQLDB0042 - Account',   -- sysname
  @server_group_id = 8,  -- int
  @server_name = N'tcp:SQLDB0042.sqladmin.lan,54321',  -- sysname
  @description = N'Account primary database server.',  -- nvarchar(2048)
  @server_type = 0,  -- int
  @server_id = @_server_id OUTPUT;  -- int, first = 1
SELECT @_server_id AS [new_server_id];

-- Delete server group from CMS. Registered servers in group will also be deleted.
EXECUTE dbo.sp_sysmanagement_delete_shared_server_group
  @server_group_id = 7;  -- int

-- A more complete way to delete server group from CMS
DECLARE @del_server_grp AS int;
SELECT @del_server_grp = server_group_id
FROM dbo.sysmanagement_shared_server_groups
WHERE [name] = N'Development';
EXECUTE dbo.sp_sysmanagement_delete_shared_server_group
  @server_group_id = @del_server_grp;

-- Delete a registered server from CMS.
EXECUTE dbo.sp_sysmanagement_delete_shared_registered_server
  @server_id = 3;  -- int

-- Move a server group to another parent server group in the CMS.
EXECUTE dbo.sp_sysmanagement_move_shared_server_group
  @server_group_id = 12,  -- int
  @new_parent_id = 9;  -- int

-- Move a registered server to another group in CMS.
EXECUTE dbo.sp_sysmanagement_move_shared_registered_server
  @server_id = 8,  -- int
  @new_parent_id = 13;  -- int

-- Add or change description to group in CMS.
EXECUTE dbo.sp_sysmanagement_update_shared_server_group
  @server_group_id = 9,  -- int
  @description = N''  -- nvarchar(2048)

-- Add or change label name or description on server in CMS.
EXECUTE dbo.sp_sysmanagement_update_shared_registered_server
  @server_id = 8,  -- int
  @server_name = N'SQLDB0042P - Account',  -- sysname
  @description = N'Account primary history database server.';  -- nvarchar(2048)

-- Rename group in CMS.
EXECUTE dbo.sp_sysmanagement_rename_shared_server_group
  @server_group_id = 9,  -- int
  @new_name = N'0)  Production';  -- sysname

-- Rename (label) a registered server in CMS.
EXECUTE dbo.sp_sysmanagement_rename_shared_registered_server
  @server_id = 8,  -- int
  @new_name = N'SQLDB0042PD - Account';  -- sysname
