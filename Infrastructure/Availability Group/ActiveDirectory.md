# Active Directory

Domain Controller:

* Server Name: DC00
* IP: 192.168.42.10
* User Name: SuperNiels (user password: )
* Domain Name: sqlbacon.lan

## Pre-Configure Computer

1) Start VM
1) Run script `PreConfigure.ps1` as Administrator
1) Shut down VM
    * `Stop-Computer -ComputerName localhost`

## Configure Computer

1) Configure VM
    * CPU: 2 vSockets each 1 vCore
    * Memory: 4 GB
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
    * `Rename-Computer -NewName 'DC00' -Restart`
    * Server will restart
1) Configure vmxnet3 Ethernet Adapter
    * Power Management: Disable "Allow computer to turn off device to save power"
    * Rename adapter "Ethernet42"
1) Remove old network adapter Ethernet0
    * Show hidden devices in Device Manager
    * Uninstall Intel 82574L Gigabit Network Connection device
1) Configure Internet Protocol Version 4 properties to static network definition
    * `Get-NetIPInterface -AddressFamily IPv4`
    * Get ifIndex of InterfaceAlias Ethernet42 (here it is 6)
    * `Set-NetIPInterface -InterfaceIndex <ifIndex> -Dhcp Disabled`
    * `New-NetIPAddress -InterfaceIndex <ifIndex> -AddressFamily IPv4 -IPAddress '192.168.42.10' -PrefixLength 24`
    * This must be done after changing network adapter as the configuration is assigned the adapter
1) Configure DNS
    * Primary DNS (IP): 192.168.42.10 (this host)
    * Secondary DNS (IP): 192.168.42.1 (the vmnet)
    * Subnet Mask: 255.255.255.0
    * Default Gateway (IP): None (host-only)
    * `Set-DnsClientServerAddress -InterfaceIndex <ifIndex> -ServerAddresses ('192.168.42.10','192.168.42.1') -PassThru`
1) Check network configuration
    * Start PowerShell:
    * `ipconfig -all`
1) Change time zone to UTC with no Daylight Saving

## Configure Domain Controller

1) Set password on Administrator user if prompted...
1) Add Windows Server roles with all features and tools:
    * Active Directory Domain Services (AD DS)
    * DNS Server
    * `Install-WindowsFeature –Name AD-Domain-Services -IncludeManagementTools`
    * `Install-WindowsFeature -Name DNS -IncludeManagementTools`
1) Promote server to Domain Controller
    * `Install-ADDSForest -DomainName 'sqlbacon.lan'` (New forrest)
    * NB: `dcpromo` does not work anymore!
1) Configure domain controller capabilities
    * Functional Level: Windows Server 2016
    * Domain Name System (DNS) server and Global Catalog (GC) on the domain
    * `$Forest = Get-ADForest`
    * `Set-ADForestMode -Identity $Forest -Server $Forest.SchemaMaster -ForestMode Windows2016Forest`
1) Set Directory Services Restore Mode (DSRM) password
    * Enter password ("u4N4WBZjgX2Cw")
1) Configure DNS
    * Do not delegate
1) Accept the NETBIOS name "SQLBACON"
1) Accept default folders
1) Start AD DS installation
    * Server will reboot
1) Change password on administrator SuperNiels when prompted (BaconGuf42)
1) Check Domain Controller
    * Server Manager shows AD DS and DNS
    * System: Computer is in domain

## Create Accounts

* Account Name: SVCSQL@sqlbacon.lan
