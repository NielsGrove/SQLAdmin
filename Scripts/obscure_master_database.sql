/*
Description
    Fooling around master-database(s)
*/
USE [tempdb];
GO

--**  Does not work  **
CREATE DATABASE [master ] ON  PRIMARY 
( NAME = N'master_data', FILENAME = N'L:\SSDB2019\Data\master_data.mdf', SIZE = 8MB, FILEGROWTH = 8MB )
 LOG ON 
( NAME = N'master_log', FILENAME = N'L:\SSDB2019\TransLog\master_log.ldf', SIZE = 8MB, FILEGROWTH = 8MB );
GO
/*
Msg 1801, Level 16, State 3, Line 8
Database 'master ' already exists. Choose a different database name.
*/

-- DROP DATABASE [ master];
CREATE DATABASE [ master] ON  PRIMARY 
( NAME = N'master0_data', FILENAME = N'L:\SSDB2019\Data\master0_data.mdf', SIZE = 8MB, FILEGROWTH = 8MB )
 LOG ON 
( NAME = N'master0_log', FILENAME = N'L:\SSDB2019\TransLog\master0_log.ldf', SIZE = 8MB, FILEGROWTH = 8MB );
GO
ALTER AUTHORIZATION ON DATABASE::[ master] TO [sa];
GO

CREATE DATABASE [ master ] ON  PRIMARY 
( NAME = N'master1_data', FILENAME = N'L:\SSDB2019\Data\master1_data.mdf', SIZE = 8MB, FILEGROWTH = 8MB )
 LOG ON 
( NAME = N'master1_log', FILENAME = N'L:\SSDB2019\TransLog\master1_log.ldf', SIZE = 8MB, FILEGROWTH = 8MB );
GO
/**  Error when [ master] exists  **
Msg 1801, Level 16, State 3, Line 18
Database ' master ' already exists. Choose a different database name.
*/

-- DROP DATABASE [master.];
CREATE DATABASE [master.] ON  PRIMARY 
( NAME = N'master_dot_data', FILENAME = N'L:\SSDB2019\Data\master_dot_data.mdf', SIZE = 8MB, FILEGROWTH = 8MB )
 LOG ON 
( NAME = N'master_dot_log', FILENAME = N'L:\SSDB2019\TransLog\master_dot_log.ldf', SIZE = 8MB, FILEGROWTH = 8MB );
GO
ALTER AUTHORIZATION ON DATABASE::[master.] TO [sa];
GO

CREATE DATABASE [master.dbo] ON  PRIMARY 
( NAME = N'master_dbo_data', FILENAME = N'L:\SSDB2019\Data\master_dbo_data.mdf', SIZE = 8MB, FILEGROWTH = 8MB )
 LOG ON 
( NAME = N'master_dbo_log', FILENAME = N'L:\SSDB2019\TransLog\master_dbo_log.ldf', SIZE = 8MB, FILEGROWTH = 8MB );
GO
ALTER AUTHORIZATION ON DATABASE::[master.dbo] TO [sa];
GO
