# Availability Group Sandbox Architecture

The sandbox is based on a SQL Server Availability Group (AG) build on Windows Server Failover Clustering (WSFC).

## Virtualization

The entire infrastruture is build in VMware Workstation Pro. this includes not only machines but also network, provisioning and configurations.

## Network

A virtual network is defined as Host-only to isolate the sandbox from the internet.

DNS server is installed on the AD DC server. Usually a DNS server is build on a seperate server or is in a specialized appliance box but as this is a sandbox this is an acceptable shortcut - for now.

### ToDo : Computers in DNS

All computers registered in DNS som that all nodes can be reached by FQDN.

### ToDo : DNS server

DNS on a dedicated server.

## Windows Server

### SQLAdmin folder

Name: #sqladmin

Will by default sort in Explorer be in top of list.

ToDo : Environmental variable (SQLAdmin)

### ToDo : Local Description

Registry Key (Description); HKLM\SOFTWARE\SQLADMIN

### ToDo : Rename Administrator

Rename default Administrator user. Security measure...

### ToDo : Local firewall

Configure local firewall with zero-trust.

## Active Directory

To bind the resources of the cluster together a Active Directory (AD) domain is needed. To host this AD domain at Domain Controller is build on windows Server. The same server host the required DNS server.

### ToDo : Create drive for database

Create GPT partition with ReFS volume for higher resilience.

### ToDo : OU structure

## Workstation

Windows 10 workstation to handle AD, SQL Server and everything else in the sandbox. This computer will have the necessary tools installed like RSAT, SSMS and editor.

### ToDo : Privileged Access Machine

## Database servers

SQL Server database servers installed with Database Engine to implement the three roles in the sandbox AG.

One service account is used for all SQL Server komponents on all servers. This is not compliant or best practice but it will work in the first iteration of this sandbox.

### ToDo : Drives

* (SCSI?)
* System (C); GPT, NTFS, 4 KB allocation unit, 64 GB
* Page & Windows dump (W); GPT, ReFS, default-4 KB, 64 GB
* Program (P); GPT, ReFS, default-4 KB, 64 GB
  * Instance Root Dir
  * Shared Feature Dir
  * Shared Feature Dir (x86)
  * Data root dir
* MSSQL Data (D); GPT, ReFS, 64 KB allocation unit, 64 GB
  * Errorlog
* MSSQL Translog (L); GPT, ReFS, 64 KB allocation unit, 64 GB
* MSSQL tempdb (T); GPT, ReFS, 64 KB allocation unit, 64 GB
* MSSQL backup (U); GPT, ReFS, 64 KB allocation unit, 128 GB

## ToDo : Managed Service Accounts

gMSA. Different service accounts on each server and for each component.

## Availability Group

### ToDo : Seperate virtual net adaptor for replication

At first with no DNS, but this could change when replication is set up with Kerberos authentication.

### ToDo : Kerberos authentication on SQL Server Availability Group replication

## Security

Initially alle machines are installed dy defaults but the intention is to harden the machines to the references and tune them to resilience, scalability and security.

### ToDo : DoD DISA STIG compliance

Compliance with official reference(-s) on Windows Server, PAM, SQL Server etc.

### ToDo : BitLocker on all drives

### ToDo : SQL Server Transparent Data Encryption (TDE)

### ToDo : Internet access with firewall

Put a virtual firewall between the DNS server and the network. In this case the DNS should **not** be on the AD DC!!!

The virtual network could be created like indicated in this article by VMware: [Custom Networking Configurations](https://www.vmware.com/support/ws55/doc/ws_net_configurations_custom.html).

The firewall itself could be created and configured like this description by Pfsense: [How to install Firewall Pfsense Virtual on VMWare](https://techbast.com/2019/05/pfsense-how-to-install-firewall-pfsense-virtual-on-vmware.html). 

## Reference

Microsoft Docs: [Failover Clustering and Always On Availability Groups](https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/failover-clustering-and-always-on-availability-groups-sql-server)

SQLAdmin blog: [DBA Security](https://sqladm.blogspot.com/p/database-security.html): AD, Windows Server, PAM etc.
