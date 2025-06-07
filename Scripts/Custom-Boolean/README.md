# T-SQL Custom Boolean Column

Scripts and technical details to SQLAdmin blog entry on Custom Boolean. See files in same folder as this file.

## ToDo

- [ ] Use default folders for database files. Just to be nice when the current storage configuration does not match a future configuration.
- [ ] Use custom schema. This is a general recommendation not to use the schemas `dbo` or `sys`.
- [ ] Use custom file group. This is a general recommendation not to use the file group `PRIMARY`.
- [ ] Add Unique Constraint on `[type]` table `type_value` column.

Some of the above might look like off track. But I really think any example should comply with general recommendations.

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

- `INSERT` many rows. The same number on alle tests.
- `UPDATE` all rows.
- Use general timing standard in T-SQL. This must be super lightweight not to affect the results.
- Each table will be tested without and with Check Constraints.
