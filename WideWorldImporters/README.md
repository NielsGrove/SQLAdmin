# SQLAdmin WideWorldImporters

Scripts to restore and configure WideWorldImporters database on various SQL Server versions.

## Download WideWorldImporters backup set

Microsoft: [WideWorldImporters download]()

## Restore WideWorldImporters database

Use the script [WideWorldImporters_restore_2025.sql](./WideWorldImporters_restore_2025.sql).

## Rebuild indexes

Rebuild all indexes in the WideWorldImporters data with the script [./]().

## Move PVS to Filegroup

The script [PVS_filegroup.2022.sql](./PVS_filegroup.2025.sql) is to move the Persistant Version Store (PVS) in a dedicated filegroup. See blog post [Put SQL Server PVS in own filegroup](https://sqladm.blogspot.com/2024/10/put-sql-server-pvs-in-own-filegroup.html).
