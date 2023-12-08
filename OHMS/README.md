# Ola Hallengren Maintenance Solution (OHMS)

Installation and configuring OHMS.

# Installing OHMS

## Create sqladmin database

# Configuring OHMS

## Create OHMS jobs

1. Job with default OHMS job naming.
    1. Change owner of job to secured owner.
1. Jobstep with logging to individual logfile per run.
    1. Change owner of jobstep to secured owner.
1. Schedule per job to reduce parallel backup activity.
    1. Change owner of schedule to secured owner

The secured owner could be the same on a job and associated jobsteps and schedules. A scured owner should not be shared among jobs.

Consider to create one job per user database. 

1. Backup jobs: Full, differential and log backups. All with check of all backup files.
1. Integrity Check.
1. Index Maintenance.
    - Hot tables could have more frequent index maintenance.
    - A really volatile table shold be consider a job to update statistics with a low scan on a frequent basis.

# Restore latest backup

1. Generate T-SQL script. Prototype in PowerShell.
1. Restore latest full backup `WITH NORECOVERY` on other server.
1. Restore backup chain up to latest transaction log backup. Make sure to restore all differential backup between latest full and latest transaction log backup.

## Restore test

After each log backup or at least each differential backup a restore should be done on another SQL Server database server.

1. Get backup metadata from source SQL Server instance.
1. Copy backup set to local drive on the restore SQL Server. This should only be done if the local storage is not a shared resource with the source.
1. Restore database on full backup chain since last full backup `WITH NORECOVERY`.
1. Restore database `WITH RECOVERY`.
1. Set database Recovery Model to `FULL`.
1. Change database owner to secured owner.
1. Update database Extended Property `MS_Description` to the standard of the organization.

When the database is restored and configured a full database integrity check (`CHECKDB`) must be executed.

- All activities must be logged in detail. Also with execution context.
- All activities should be timed (`Stopwatch`).
