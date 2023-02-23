/*
Description
  RAISERROR message with ISO-8601 timestamp.
  Can be used inside batch block to give status.
*/

DECLARE @_start datetime2 = SYSDATETIME();

DECLARE @_msg nvarchar(2047) = CONVERT(nchar(23), GETUTCDATE(), 126) + N'Z : Get ready...';
RAISERROR(@_msg, 0,0) WITH NOWAIT;

WAITFOR DELAY '00:00:04';  -- 4 seconds

DECLARE @_finish datetime2 = SYSDATETIME();
DECLARE @_duration int = DATEDIFF(ms, @_start, @_finish);

SET @_msg = N'Finish after %i ms.';
RAISERROR(@_msg, 0,0, @_duration) WITH NOWAIT;
GO


DECLARE @_msg nvarchar(2047) = CONVERT(nchar(23), GETUTCDATE(), 126) + N'Z : 2nd run...';
RAISERROR(@_msg, 0,0) WITH NOWAIT;
GO