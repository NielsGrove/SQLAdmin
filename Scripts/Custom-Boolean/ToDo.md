# T-SQL Custom Boolean Column - ToDo

- [ ] Test each table without and with Check Constraints.
- [ ] Use default folders for database files. Just to be nice when the current storage configuration does not match a future configuration.
- [ ] Use custom schema. This is a general recommendation not to use the schemas `dbo` or `sys`.
- [ ] Use custom file group. This is a general recommendation not to use the file group `PRIMARY`.
- [ ] Add Unique Constraint on `[type]` table `type_value` column.

## Examples

- [x] Function `[string_to_bit]`.
- [x] Procedure using `string_to_bit` function.
- [x] Examples on executing stored procedure using `string_to_bit`.

Some of the above might look like off track. But I really think any example should be with various scenarios, good and bad.
