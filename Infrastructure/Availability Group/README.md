
# SQL Server AlwaysOn Availability Group Sandbox

Build a Availability Group sandbox with three replica. One Primary replica, one sync replica and one async replica. The sandbox also contain necessary resources and tools.

At first this will be a rather manual process, but it is my intention to automate as much as I can figure out.

## Infrastructure

* Active Directory Domain Controller hosting domain.
* Databaseservers, three nodes in domain.
* Witness file server in domain.
* Privileged Access Machine workstation in domain.

All computers are virtual running on VMware Workstation Pro. Each computer is based on a full clone of an existing vm that is updated but with minimum configuration.

A virtual network is defined as Host-only to isolate the sandbox from the internet.

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
    * Use VMware REST API or vmrun tool?
1) Configure VM
    * CPU: 2 vSockets each 1 vCore
    * Memory: 2 GB
    * Network: VMnet13
1) Configure vmxnet paravirtualized network ([vmxnet3](https://sqladm.blogspot.com/2019/03/vmxnet3-network-adapter.html)) adapter
1) Start computer
1) sysprep
    * Start Windows Shell (CMD):
    * `%WINDIR%\system32\sysprep\sysprep.exe /generalize /shutdown /oobe`
    * Reference: [Sysprep (Generalize) a Windows installation](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep--generalize--a-windows-installation)
1) Start computer
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
1) ? Rename Administrator to SuperNiels and set password ?
    * ( Password never expires )
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
1) Configure Print Spooler service
    * Start PowerShell as administrator:
    * `Stop-Service -Name 'spooler'`
    * `Set-Service -Name 'spooler' -StartupType 'Disabled'`

### Configure Domain Controller

1) Set password on Administrator user
1) Add Windows Server roles with all features and tools:
    * Active Directory Domain Services (AD DS)
    * DNS Server
    * Start PowerShell as Administrator:
    * `Install-WindowsFeature –Name AD-Domain-Services -IncludeManagementTools`
1) Promote server to Domain Controller
    * Use Server Manager or...
    * Start PowerShell as Administrator:
    * `dcpromo` - Does not work anymore!
    * New forrest (Domain Name)
1) Configure domain controller capabilities
    * Functional Level: Windows Server 2016
    * Domain Name System (DNS) server and Global Catalog (GC) on the domain
1) Set Directory Services Restore Mode (DSRM) password
    * Enter password ("u4N4WBZjgX2Cw")
1) Configure DNS
    * Do not delegate
1) Accept the NETBIOS name "SQLBACON"
1) Accept default folders
    * ? Create GPT partition with ReFS drive for higher resilience ?
1) Start AD DS installation
    * Server will reboot
1) Change password on administrator SuperNiels when prompted (BaconGuf42)
1) Check Domain Controller
    * Server Manager shows AD DS and DNS
    * System: Computer is in domain

## Create PAM Workstation

* Computer Name: PAM00
* IP: 192.168.42.20

1) Clone VM
    * Full Clone
1) Configure VM
    * CPU: 2 vSockets each 1 vCore
    * Memory: 8 GB
    * Network: VMnet13
1) Configure vmxnet paravirtualized network
1) Start computer
1) sysprep
    * Start Windows Shell (CMD):
    * `%WINDIR%\system32\sysprep\sysprep.exe /generalize /shutdown /oobe`
1) Configure network: IP
1) Add computer to AD
1) Install latest SSMS
1) Install PowerShell 7

## Create Database Servers

### General Configuration

1) Clone VM
1) sysprep
1) Configure network: IP
1) Add computer to AD
1) Create service accounts for database instance and SQL Agent (gMSA)
1) Install SQL Server: Database Engine
1) Install latest SQL Server CU
1) Configure backup (OHMS)

Addition configurations to add later:

* Storage: Different disks for SQL Server data, translog and backup

### Configure DB Server A

* Server Name: SQL00
* IP: 192.168.42.30

1) General configuration (see above)

### Configure DB Server B

* Server Name: SQL01
* IP: 192.168.42.31

1) General configuration (see above)

### Configure DB Server C

* Server Name: SQL02
* IP: 192.168.42.32

1) General configuration (see above)

## Create Witness File Share

* Server Name: 
* IP: 
* Share Name: 

1) sysprep

## Create Cluster

* Cluster Name: 

## Create Availability Group

* AG Name: 
* Listener: 

1) Configure Quorum Voting
