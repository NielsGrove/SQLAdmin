# T-SQL Custom Boolean Column

Scripts and technical details to SQLAdmin blog entry on Custom Boolean. See files in same folder as this file.

## Sandbox Database

The simple database `[custom_00]` with no special configurations. But there are some initial test runs to make sure the files has a suitable size that will avoid autogrows.

## Sandbox Tables

One table setup for each test run. Each table with 16 similar columns to fit with more than one Byte when using `bit` type:

1. `[null_0]`: Nullable columns. Just testing the time to `INSERT`, but not `UPDATE`. This might be somewhat out of context and will wait.
1. `[fixed_0]`: Ordinary `char` columns. The width is set to five characters that match the string value `false`.
1. `[nfixed_0]`: `nchar` columns.
1. `[var_0]`: `varchar` columns. Will be tested from narrow (`n`) to wide (`false`) values.
1. `[nvar_0]`: `nvarchar` columns. Will be tested from narrow (`æ`) to wide (`æÆØÅå`) values
1. `[type_0]`: Type table relation where the type table holds the correct (two) values.

?) Unicode columns? It is quite rare that a database or a column is with a unicode collation like "(TBD)". So this case I think is so rare that I will save for another day.

## Test Custom Boolean

For this test I will use the two boolean values `true` and `false` on fixed columns.

1. Truncate table
1. `INSERT` 10 000 rows. The same number on alle tests.
1. `UPDATE` all rows.

- Use general timing standard in T-SQL. This must be super lightweight not to affect the results.

### Table `fixed_test`

Average execution time = (Insert) (Update).

Run | Time | Time
-- | -- | --
0 | 00:00:02 | 00:02:19
1 | 00:00:02 | 00:02:21
2 | 00:00:02 | 00:02:22
3 | 00:00:02 | 00:02:26
4 | 00:00:02 | 00:02:23
5 | 00:00:02 | 00:02:21
6 | 00:00:02 | 00:02:24
7 | 00:00:02 | 00:02:21
8 | 00:00:02 | 00:02:26
9 | 00:00:02 | 00:02:24

These numbers are one with Check Constraint on column `col_00`. Rerun with same Check Constraint on all 16 columns.
