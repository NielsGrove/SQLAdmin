
# SQL Server AlwaysOn Availability Group Sandbox

Build a Availability Group sandbox with three replica. One Primary replica, one sync replica and one async replica. The sandbox also contain necessary resources and tools.

At first this will be a rather manual process, but it is my intention to automate as much as I can figure out.

The architecture of this sandbox is in the document [Availability Group Sandbox Architecture](SqlAgSandboxArchitecture.md).

## Infrastructure

* Active Directory Domain Controller hosting domain.
* Databaseservers, three nodes in domain.
* Witness file server in domain.
* Privileged Access Machine (PAM) workstation in domain.

All computers are virtual running on VMware Workstation Pro. Each computer is based on a full clone of an existing vm that is updated but with minimum configuration.

This sandbox is build on Windows Server 2019 Std Ed, SQL Server 2019 Ent Ed and Windows 10 Pro. Automation is build in PowerShell 7 and T-SQL.

## Provision Process

This is a simple overview of the provision process for the AG-sandbox.

1) Create virtual network in VMware Workstation Pro.
1) Create DC VM.
1) Create PAM VM.
1) Create database server VMs.
1) Create witness file share.
1) Create cluster.
1) Create AG.

See details in the following sections.

### Things to consider

* BitLocker on all drives
* SQL Server Transparent Data Encryption (TDE)
* Kerberos authentication on SQL Server Availability Group replication
* DoD DISA STIG compliance on Windows Server, PAM, SQL Server etc.

## Create virtual network

* Custom network: VMnet13, host-only
* Subnet IP: 192.168.42.0
* Subnet mask: 255.255.255.0
* DHCP: (none)

## Create Domain Controller

* Server Name: DC00
* IP: 192.168.42.10
* User Name: SuperNiels (user password: )
* Domain Name: sqlbacon.lan

### Configure Computer

1) Clone VM
    * Full Clone
    * (from VMware host: `vmrun clone ...`)
1) Configure VM
    * CPU: 2 vSockets each 1 vCore
    * Memory: 2 GB
    * Network: VMnet13
    * (from VMware host: `vmrun setNetworkAdapter ...`)
1) Configure paravirtualized network ([vmxnet3](https://sqladm.blogspot.com/2019/03/vmxnet3-network-adapter.html)) adapter
1) Start VM
1) sysprep
    * Start Windows Shell (CMD):
    * `%WINDIR%\system32\sysprep\sysprep.exe /generalize /shutdown /oobe`
    * (from VMware host: `vmrun ...`)
    * Reference: [Sysprep (Generalize) a Windows installation](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep--generalize--a-windows-installation)
1) Start VM
    * Configure
        * Region: United States
        * Language: English (United States)
        * Keyboard: Danish
    * Enter License Key
1) Check that Windows Server is activated
1) Rename computer
    * Start PowerShell as administrator:
    * `Rename-Computer -NewName 'DC00' -Restart`
    * Server will reboot
1) Configure vmxnet3 Ethernet Adapter
    * Power Management: Disable "Allow computer to turn off device to save power"
    * Rename adapter "Ethernet42"
1) Remove old network adapter Ethernet0
    * Show hidden devices in Device Manager
    * Uninstall Intel 82574L Gigabit Network Connection device
1) Configure Internet Protocol Version 4 properties to static network definition
    * ? Start PowerShell:
    * ? `Get-NetIPInterface -AddressFamily IPv4`
    * ? Get ifIndex of InterfaceAlias Ethernet42 (here it is 6)
    * ? `Set-NetIPInterface -InterfaceIndex 6 -Dhcp Disabled`
    * ? `New-NetIPAddress -InterfaceIndex 6 -AddressFamily IPv4 -IPAddress '192.168.42.10' -PrefixLength 24 -DefaultGateway ''`
    * ? `Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses "192.168.42.10" -PassThru`
    * This must be done after changing network adapter as the configuration is assigned the adapter
1) Configure DNS
    * Primary DNS (IP): 192.168.42.10 (this host)
    * Secondary DNS (IP): 192.168.42.1 (the vmnet)
    * Subnet Mask: 255.255.255.0
    * Default Gateway (IP): None (host-only)
1) Check network configuration
    * Start PowerShell:
    * `ipconfig -all`
1) Change drive letter on CD-ROM from D to X (xternal)
1) Change time zone to UTC with no Daylight Saving
1) Configure Print Spooler service
    * Start PowerShell as administrator:
    * `Stop-Service -Name 'spooler'`
    * `Set-Service -Name 'spooler' -StartupType 'Disabled'`
1) Create admin folder
    * `vmrun createDirectoryInGuest ...`
1) Install PowerShell 7 - or later

### Configure Domain Controller

1) Set password on Administrator user if prompted...
1) Add Windows Server roles with all features and tools:
    * Active Directory Domain Services (AD DS)
    * DNS Server
    * Start PowerShell as Administrator:
    * `Install-WindowsFeature –Name AD-Domain-Services -IncludeManagementTools`
    * `Install-WindowsFeature -Name DNS -IncludeManagementTools`
1) Promote server to Domain Controller
    * Use Server Manager or...
    * Start PowerShell as Administrator:
    * `Install-ADDSForest -DomainName 'sqlbacon.lan'` (New forrest)
    * NB: `dcpromo` does not work anymore!
1) Configure domain controller capabilities
    * Functional Level: Windows Server 2016
    * Domain Name System (DNS) server and Global Catalog (GC) on the domain
    * Start PowerShell as Administrator:
    * `$Forest = Get-ADForest`
    * `Set-ADForestMode -Identity $Forest -Server $Forest.SchemaMaster -ForestMode Windows2016Forest`
1) Set Directory Services Restore Mode (DSRM) password
    * Enter password ("u4N4WBZjgX2Cw")
1) Configure DNS
    * Do not delegate
1) Accept the NETBIOS name "SQLBACON"
1) Accept default folders
    * ? ToDo: Create GPT partition with ReFS drive for higher resilience ?
1) Start AD DS installation
    * Server will reboot
1) Change password on administrator SuperNiels when prompted (BaconGuf42)
1) Check Domain Controller
    * Server Manager shows AD DS and DNS
    * System: Computer is in domain

## Create PAM Workstation

See document ([link](Workstation.md)).

## Create Fileserver

1) Clone VM
1) Configure VM
1) Configure vmxnet paravirtualized network
1) Add disk(-s) for file share
    * ? Storage Space ?
1) sysprep
1) Configure network
1) Add computer to AD
1) Configure file share

## Create Database Servers

See document ([link](DatabaseServers.md)).

## Create Cluster

* Cluster Name: 

## Create Availability Group

* AG Name: 
* Listener: 

[Troubleshooting an AG Failure](https://www.joshthecoder.com/2018/12/03/always-run-rhs-in-separate-process.html)

1) Configure Quorum Voting
