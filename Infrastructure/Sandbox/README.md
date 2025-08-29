# SQLadmin Sandbox Infrastructure

Scripts to build and configure _SQLAdmin_ sandbox infrastructure.

## Windows Server

See details in [blog post](https://sqladm.blogspot.com/2023/09/sandbox-windows-server-in-vmware.html).

- _Network adapter_: Change to paravirtual adapter „vmxnet3“. This is a off-line operation I have described earlier.
- _Network adapter_: Do not allow to turn off device to save energy.
- _Network adapter_: Show hidden devices in Device Manager and remove old Intel Gigabit Network Connection.
- _Keyboard_: Add Danish keyboard to English profile and remove English keyboard. This is as I live in Denmark.
- _Location_: Change to UK and set to UTC to avoid daylight savings etc.
- _Server Manager_: Do not start automatic.
- _Print Spooler_: Stop and disable service.

### Storage

| Drive | Name | Size | NTFS | Comments |
| --- | --- | --- | --- | --- |
| C | System | 64 GB | default | | Windows OS and tools |
| P | Program | 64 GB | default | | SQL Server |
| D | Data | 48 GB | 64 KB | | User database (mdf & ndf) |
| L | Translog | 32 GB | 64 KB | | User db & tempdb (ldf) |
| T | tempdb | 32 GB | 64 KB | tempdb data (mdf & ndf) |
| X | Backup | 128 GB | | 64 KB | | Full, diff & log backup |

1. Create one disk at a time: One-Piece Flow (Lean)- Must be done manually in VMware Workstation. 1. Can be scripted in vCenter with PowerCLI.
1. In VMware Workstation NVMe can only be added offline.
1. Split virtual disk into multiple files.
1. Do not allocate all space now.

1. Only Simple Volume.
1. Quick format.

- Large FRS.
- All partitions are GPT.

### PowerShell

Latest PowerShell must be installed. On Windows Server you might have to download the MSI installation set and install PowerShell from that.

## SQL Server Database Engine

1. Connect VM CD-drive to SQL Server ISO-file
1. Run SETUP.EXE
1. Select „SQL Server Developer Edition“
1. Select "Database Engine Services" and "Full-Text…"
1. Place "Instance Root Directory" on another physical drive than Windows, e.g. "P:\Program_Files\Microsoft_SQL_Server\". This is to spread preassure on (local) storage units.
1. Name the (Database Engine) instance, e.g. „SSDB00“. This will allow side-by-side installation of different SQL Server versions. On the other hand I usually does not recommend instanse name with version information. The instance name in shared installations should be generic – like a dumb database key.
1. Change Service Startup Type to "Manual". When running several instances this will help you control local resources on your workstation. With virtual workstations I usually create one VM to each instance.
1. Set „Grant Perform Volume Maintenance Task priviledge to SQL Server Database Engine Service“. This is to speed up database file (auto-)growths which might be when expanding the physical data model. This is really relevant on a workstation where you experiment. On the other hand I would never use Auto Shrink (AUTO_SHRINK) even in a sandbox.
1. Collation tab: Use collation "Latin_General_100 AS KS WS" maybe with UTF-8.
1. Add Current User as SQL Server administrator. Adding (Local) Administrators is not enough.
1. Set Directories. Define seperate paths for
  - Data
  - TransactionLog
  - Backup
  - tempdb
where [tempdb] transaction log is with the other user database transaction logs.
1. Set tempdb data and log
1. Set MAXDOP to 4
1. Set memory to Recommended
1. Run installation
1. Close SQL Server Installation
1. Disconnect CD-drive
1.Restart VM

### SSDB Configuration

Script: TBD...

## LAN

## Active Directory.
See details in [blog post](https://sqladm.blogspot.com/2018/12/sandbox-active-directory-in-vmware.html).

## Windows Cluster

## SQL Server AlwaysOn Availability Group
