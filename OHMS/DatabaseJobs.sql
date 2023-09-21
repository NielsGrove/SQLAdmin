/*
Description
  Create OHMS jobs to maintain one given database.
  1) Full backup
  2) Differential backup
  3) Log backup
  4) Integrity check
*/

DECLARE @database_name sysname = N'no_database';

DECLARE @backup_directory NVARCHAR(4000) = N'\\noserver.sqladmin.lan\doesnotexist\';

DECLARE @full_job_name NVARCHAR(128) = N'DatabaseBackup - ' + @database_name + N' - FULL';
DECLARE @full_step_name sysname = @full_job_name;
DECLARE @full_schedule_name sysname = @full_job_name + N' schedule';

DECLARE @diff_job_name NVARCHAR(128) = N'';
DECLARE @diff_step_name sysname = N'';
DECLARE @diff_schedule_name sysname = N'';

DECLARE @log_job_name NVARCHAR(128) = N'';
DECLARE @log_step_name sysname = N'';
DECLARE @log_schedule_name sysname = N'';


/* Global variables */
DECLARE @msg NVARCHAR(2047);
DECLARE @_obj_owner sysname = SUSER_SNAME(0x01);
SELECT @msg = N'DEBUG - obj_owner = ' + @_obj_owner;
RAISERROR(@msg, 0,0) WITH NOWAIT;

DECLARE @job_category_id INT = (SELECT [category_id] FROM msdb.dbo.syscategories WHERE [name]=N'Database Maintenance');
SELECT @msg = N'DEBUG - job_category_id = ' + CAST(@job_category_id AS nvarchar(32));
RAISERROR(@msg, 0,0) WITH NOWAIT;


/*  Full backup */
SELECT @msg = LEFT(CONVERT(nvarchar(128), GETUTCDATE(), 127), 22) + N'Z : Create full backup job for [' + @database_name + N']...';
RAISERROR(@msg, 0,0) WITH NOWAIT;
SELECT @msg = N'DEBUG - full_job_name = ' + @full_job_name
RAISERROR(@msg, 0,0) WITH NOWAIT;

DECLARE @_full_job_id UNIQUEIDENTIFIER;
--/*
EXECUTE [msdb].[dbo].[sp_add_job]
  @job_name = @full_job_name,
  @description=N'Source: https://ola.hallengren.com/',
  @category_id=@job_category_id,
  @owner_login_name = @_obj_owner,
  @job_id = @_full_job_id OUTPUT;
--*/
SELECT @msg = N'DEBUG - job_id = ' + CAST(@_full_job_id AS nvarchar(36));
RAISERROR(@msg, 0,0) WITH NOWAIT;
SELECT @msg = N'Clean-Up:' + CHAR(13)+CHAR(10) +
  N'EXECUTE [msdb].[dbo].[sp_delete_job]' + CHAR(13)+CHAR(10) +
  N'  @job_name = N''' + @full_job_name + ''',' + CHAR(13)+CHAR(10) +
  N'  @delete_history = 1;'
RAISERROR(@msg, 0,0) WITH NOWAIT;

SELECT @msg = LEFT(CONVERT(nvarchar(128), GETUTCDATE(), 127), 22) + N'Z : Create full backup step for [' + @database_name + N']...';
RAISERROR(@msg, 0,0) WITH NOWAIT;
DECLARE @full_command NVARCHAR(MAX) = N'EXECUTE [dbo].[DatabaseBackup]' + CHAR(13)+CHAR(10) +
  N'  @Databases=N''' + @database_name + N''',' + CHAR(13)+CHAR(10) +
  N'  @Directory=N''' + @backup_directory + N''',' + CHAR(13)+CHAR(10) +
  N'  @BackupType=''FULL'',' + CHAR(13)+CHAR(10) +
  N'  @Verify=''Y'',' + CHAR(13)+CHAR(10) +
  N'  @CleanupTime=36,' + CHAR(13)+CHAR(10) +
  N'  @CleanupMode=''AFTER_BACKUP'',' + CHAR(13)+CHAR(10) +
  N'  @Compress=NULL,' + CHAR(13)+CHAR(10) +
  N'  @CheckSum=''Y'',' + CHAR(13)+CHAR(10) +
  N'  @NumberOfFiles=8;'

SELECT @msg = LEFT(CONVERT(nvarchar(128), GETUTCDATE(), 127), 22) + N'Z : Create full backup schedule for [' + @database_name + N']...';
RAISERROR(@msg, 0,0) WITH NOWAIT;


/*  Diff backup  */


/*  Log backup  */


/*  Integrity check  */


/*  Clean-Up  */
/*
EXECUTE [msdb].[dbo].[sp_delete_job]
  @job_name = N'DatabaseBackup - no_database - FULL',
  @delete_history = 1;
--*/
