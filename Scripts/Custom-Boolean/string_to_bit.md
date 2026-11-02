# T-SQL function [string_to_bit]

Anti-pattern example to SQL Server _Custom Boolean_ column.

This function tries to fix lack of using `bit` type in SQL Server column and associated application. This is used to get a `bit` value from a string stored in a _Custom Boolean_ string value column.

Also there are other challenges in this example, such as - but not limited to

- No real input validation. If the string value is unknown then _null_ is returned by the function. `NULL` should only be used to indicate missing value, not a functional information.
- Empty string is returned as _false_ value. This is personal choise made by the developer without any objective motivation.
- Lists of positives and negatives must be maintained manually. Is not direct bound to T-sql Check Constraints on the _Custom Boolean_ column. Correlations must be maintained manually by the developer.
- The elements in the lists of positives and negatives are case-sesitive. Maybe. This actually depends on the collation of the _Custom Boolean_ column, which in this example is "_CI_AS_KS_WS". The string in the function parameter should be converted to upper or lower case before comparison with list. Which must have elements with the same casing. See examples in the buttom of "string_to_bit.sql".
