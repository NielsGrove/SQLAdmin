# Database Servers

## Preparations

1) Create service account for database instance and SQL Agent
    * Name: MSSQL
    * Password: Pa$$word42
    * Disable - User must change password at next logon
    * Enable - User cannot change password
    * Enable - Password never expires
    * Disable - Account is disabled
1) Configure service account
    * Remote Control
      * Disable - Enable Remote control
    * Environment
      * Disable - Connect client drives at logon
      * Disable - Connect client printers and logon
      * Disable - Default to main client printer

## General setup

### Clone VM

Full Clone

### Pre-configuration

While the VM has access to the internet:

1) Start VM
1) Run PowerShell script `PreConfigure.ps1` as Administrator.
1) Install Failover Clustering Feature
    * `(TBD)`
1) `Import-Module FailoverClusters`
1) Copy SQL Server installation sets to VM sqladmin-folder
    * Latest CU
    * OHMS script files
1) Shut down VM: `Stop-Computer -ComputerName localhost`

### Configuration

1) Configure VM
    * CPU: 4 vSockets each 1 vCore
    * Memory: 8 GiB
    * Network: VMnet13 (this will take the VM off the internet)
1) Configure vmxnet3 paravirtualized network
1) Start VM
1) sysprep
    * Start Windows Shell (CMD):
    * `%WINDIR%\system32\sysprep\sysprep.exe /generalize /shutdown /oobe`
1) Start VM
    * Configure
        * Region: United States
        * Language: English (United States)
        * Keyboard: Danish
    * Enter License Key
1) Check that Windows Server is activated
1) Rename computer
    * `Rename-Computer -NewName 'SQL00' -Restart`
1) Configure vmxnet3 Ethernet Adapter
    * Power Management: Disable "Allow computer to turn off device to save power"
    * Rename adapter "Ethernet42"
1) Remove old network adapter Ethernet0
    * Show hidden devices in Device Manager
    * Uninstall Intel 82574L Gigabit Network Connection device
1) Configure network: IP
    * Enable Receive Side Scaling (RSS): `Enable-NetAdapterRss -Name 'Ethernet42'`
    * `Get-NetIPInterface -AddressFamily IPv4`
    * Get ifIndex of InterfaceAlias Ethernet42 (here it is 6)
    * `Set-NetIPInterface -InterfaceIndex 6 -Dhcp Disabled`
    * `New-NetIPAddress -InterfaceIndex 6 -AddressFamily IPv4 -IPAddress '192.168.42.30' -PrefixLength 24`
    * `Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses ('192.168.42.10','192.168.42.1') -PassThru`
    * This must be done after changing network adapter as the configuration is assigned the adapter
1) Check network configuration
    * `ipconfig -all`
1) Add computer to AD
    * `Add-Computer -DomainName 'SQLBACON' -Restart` (Does not work in PowerShell 7)
    * Enter credentials on SuperNiels (see DC configuration)
    * Computer will restart
1) Install SQL Server: Database Engine
    * Mount ISO to VM from VMware host
    * Components: Database Engine
    * Default instance
    * SQL Agent - automatic start
    * Account Name: SQLBACON\MSSQL
    * Grant Perform Volume Maintenance Task
    * Collation: Latin_General_100, Accent-sensitive, Kana-sensitive, Width-sensitive, UTF-8
    * Administrators: Administrator, SuperNiels
1) Install latest SQL Server CU
    * `(TBD)`
1) Stop and disable SQL VSS Writer service
1) Configure backup (OHMS)

### ToDo : Addition configurations

1) Storage: Different disks for SQL Server data, translog and backup
    * Paravirtualized adaptor
    * Basic Disk - GPT partition - ReFS volume with 64 KB Allocation Unit

## Configure DB Server A

* Server Name: SQL00
* IP: 192.168.42.30

1) General configuration (see above)

## Configure DB Server B

* Server Name: SQL01
* IP: 192.168.42.31

1) General configuration (see above)

## Configure DB Server C

* Server Name: SQL02
* IP: 192.168.42.32

1) General configuration (see above)
