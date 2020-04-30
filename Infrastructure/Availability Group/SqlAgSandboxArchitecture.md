# Availability Group Sandbox Architecture

The sandbox is based on a SQL Server Availability Group (AG) build on Windows Server Failover Clustering (WSFC).

## Virtualization

The entire infrastruture is build in VMware Workstation Pro. this includes not only machines but also network, provisioning and configurations.

A virtual network is defined as Host-only to isolate the sandbox from the internet.

## Active Directory

To bind the resources of the cluster together a Active Directory (AD) domain is needed. To host this AD domain at Domain Controller is build on windows Server. The same server host the required DNS server. Usually a DNS server is build on a seperate server or is in a specialized appliance box but as this is a sandbox this is an acceptable shortcut - for now.

## Privileged Access Machine

Windows 10 workstation to handle AD, SQL Server and everything else in the sandbox. This computer will have the necessary tools installed like RSAT, SSMS and editor.

## Database servers

SQL Server database servers installed with Database Engine to implement the three roles in the sandbox AG.

## Availability Group

(Seperate virtual net adaptor for replication)

## Security

Initially alle machines are installed dy defaults but the intention is to harden the machines to the references and tune them to resilience, scalability and security.

### ToDo : Internet access with firewall

Put a virtual firewall between the DNS server and the network. In this case the DNS should **not** be on the AD DC!!!

The virtual network could be created like indicated in this article by VMware: [Custom Networking Configurations](https://www.vmware.com/support/ws55/doc/ws_net_configurations_custom.html).

The firewall itself could be created and configured like this description by Pfsense: [How to install Firewall Pfsense Virtual on VMWare](https://techbast.com/2019/05/pfsense-how-to-install-firewall-pfsense-virtual-on-vmware.html). 

## Reference

Microsoft Docs: [Failover Clustering and Always On Availability Groups](https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/failover-clustering-and-always-on-availability-groups-sql-server)

SQLAdmin blog: [DBA Security](https://sqladm.blogspot.com/p/database-security.html): AD, Windows Server, PAM etc.
