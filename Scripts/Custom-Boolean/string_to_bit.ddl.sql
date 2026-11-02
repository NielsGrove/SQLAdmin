/*
Description
	Create function [string_to_bit].
*/
USE [custom_bool];
GO

/*
Description
    Return a bit (nullable) value on a given string value.
    DO NOT USE!!! Anti-pattern example full of bad things. See more in string_to_bit.md.
*/
CREATE OR ALTER FUNCTION [dbo].[string_to_bit]
( @custom_boolean VARCHAR(5) )
RETURNS BIT
AS
BEGIN
    DECLARE @_return_bit AS BIT;

    IF(@custom_boolean IN ('J', 'JA', 'Y', 'YES', 'Yes', 'true'))
        SET @_return_bit = 1;
    ELSE IF (@custom_boolean IN ('', 'N', 'NEJ', 'NO', 'Nej', 'No', 'false'))
        SET @_return_bit = 0;
    ELSE
        SET @_return_bit = NULL;

    RETURN @_return_bit;
END
GO

EXECUTE [sys].[sp_addextendedproperty]
    @name=N'MS_Description', 
    @value=N'DO NOT USE!!! Anti-pattern example.', 
    @level0type=N'SCHEMA',@level0name=N'dbo', 
    @level1type=N'FUNCTION',@level1name=N'string_to_bit';
GO


/*
Description
    Example on using [string_to_bit].
*/
CREATE OR ALTER PROCEDURE [dbo].[get_bit_from_string]
	@cust_bool VARCHAR(5)
AS
BEGIN
	SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET QUOTED_IDENTIFIER ON

	SELECT
        @cust_bool AS [cust_bool],
        [dbo].[string_to_bit]( @cust_bool ) AS [bit_val];
END
GO

EXECUTE [sys].[sp_addextendedproperty]
    @name=N'MS_Description', 
    @value=N'Anti-pattern example.', 
    @level0type=N'SCHEMA',@level0name=N'dbo', 
    @level1type=N'PROCEDURE',@level1name=N'get_bit_from_string';
GO


/***  Example  ***/
EXECUTE [dbo].[get_bit_from_string] @cust_bool = 'yES';
EXECUTE [dbo].[get_bit_from_string] @cust_bool = 'nO';
EXECUTE [dbo].[get_bit_from_string] @cust_bool = '';
EXECUTE [dbo].[get_bit_from_string] @cust_bool = 'NaN';
EXECUTE [dbo].[get_bit_from_string] @cust_bool = NULL;
EXECUTE [dbo].[get_bit_from_string] @cust_bool = TRUE;
EXECUTE [dbo].[get_bit_from_string] @cust_bool = FALSE;
EXECUTE [dbo].[get_bit_from_string] @cust_bool = 42;
