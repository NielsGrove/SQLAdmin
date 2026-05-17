/*
Description
	Simple data manipulation in Custom Boolean sandbox.
*/
USE [custom_bool];
GO

SELECT * FROM [custom_bool].[dbo].[fixed_test];

/*  Test Constraint  --*
INSERT INTO [dbo].[fixed_test]
    ([col_00],[col_01],[col_02],[col_03],[col_04],[col_05],[col_06],[col_07],[col_08],[col_09],[col_10],[col_11],[col_12],[col_13],[col_14],[col_15])
VALUES
    ('JA','Yes','yes','Y','y','NO','No','no','N','n','Yes','No','y','n','yes','no');
GO
--*
Msg 547, Level 16, State 0, Line 8
The INSERT statement conflicted with the CHECK constraint "CK_col_00". The conflict occurred in database "custom_bool", table "dbo.fixed_test", column 'col_00'.
The statement has been terminated.
*/

SET NOCOUNT ON;
INSERT INTO [custom_bool].[dbo].[fixed_test]
    --([col_00],[col_01],[col_02],[col_03],[col_04],[col_05],[col_06],[col_07],[col_08],[col_09],[col_10],[col_11],[col_12],[col_13],[col_14],[col_15])
VALUES
    ('YES','Yes','yes','Y','y','NO',
    'No','no','N','n','Yes',
    'No','y','n','yes','no');
GO 10000

SET NOCOUNT ON;
UPDATE [custom_bool].[dbo].[fixed_test]
SET [col_00]='n', [col_01]='No', [col_02]='no', [col_03]='No', [col_04]='no', [col_05]='Y',
    [col_06]='Yes', [col_07]='y', [col_08]='YES', [col_09]='yes', [col_10]='N',
    [col_11]='Yes', [col_12]='No', [col_13]='Yes', [col_14]='n', [col_15]='y';
GO 10000

USE [tempdb];
GO
