/*
Description
  Notes on SQL Server Audit

Link
  Microsoft Docs: SQL Server Audit (Database Engine)
  (https://docs.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-database-engine)

Link
  Microsoft Docs: sys.fn_get_audit_file
  (https://docs.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-get-audit-file-transact-sql)
*/


CREATE SERVER AUDIT SQLAdmin_Audit
  TO FILE ( FILEPATH ='E:\SQLAudit\' );
GO

CREATE SERVER AUDIT SPECIFICATION SQLAdmin_Audit_Spec
FOR SERVER AUDIT SQLAdmin_Audit
    ADD (FAILED_LOGIN_GROUP);
GO  

ALTER SERVER AUDIT SQLAdmin_Audit  
WITH (STATE = ON);  
GO  
