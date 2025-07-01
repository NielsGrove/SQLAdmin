/*
Description
	Examples on using Brent Ozar's sp_Blitz.
*/
USE [sqladmin];
GO

/**  sp_Blitz  **/
EXECUTE [dbo].[sp_Blitz] @CheckUserDatabaseObjects = 0;

EXECUTE [dbo].[sp_Blitz];

EXECUTE [dbo].[sp_Blitz] @CheckServerInfo = 1;


/** sp_BlitzCache  */
EXECUTE [dbo].[sp_BlitzCache];


/**  sp_BlitzFirst  **/
EXECUTE [dbo].[sp_BlitzFirst];


/**  sp_BlitzWho  **/
EXECUTE [dbo].[sp_BlitzWho];
