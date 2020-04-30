# Workstation (PAM)

* Computer Name: PAM00
* IP: 192.168.42.20

## Clone VM

    * Full Clone

## Pre-configuration

While the machine has access to the internet:

1) Start VM
1) Install latest PowerShell (7+)
1) Change drive letter on CD-ROM from D to X (xternal)
1) Configure Print Spooler service
    * Start PowerShell as administrator (Elevate with PAM00\LocalNiels):
    * `Stop-Service -Name 'spooler'`
    * `Set-Service -Name 'spooler' -StartupType 'Disabled'`
1) Create admin folder
    * `New-Item -Path 'C:\' -Name '#sqladmin' -ItemType 'Directory'`
    * (from VMware host: `vmrun createDirectoryInGuest ...`)
1) Install RSAT
    * Add Windows Capability:
    * `Get-WindowsCapability -Online | Where-Object { $_.Name -like "Rsat.Dns.Tools*" }`
    * See the full name of the capability. Notice the version info in the end of the name
    * `Add-WindowsCapability -Online -Name Rsat.Dns.Tools~~~~0.0.1.0` in this case
    * ERROR when off internet: `Add-WindowsCapability : Add-WindowsCapability failed. Error code = 0x8024402c`
    * Check installation
    * `Get-WindowsCapability -Online | Where-Object { $_.Name -like "Rsat.Dns.Tools*" }`
1) Install latest SSMS
    * Install SqlServer module
    * `Install-Module -Name SqlServer -AllowClobber`
1) Shut down VM: `shutdown.exe /s`

## Configuration

1) Configure VM
    * CPU: 2 vSockets each 1 vCore
    * Memory: 8 GiB
    * Network: VMnet13
1) Configure vmxnet paravirtualized network
    * SQLAdmin blog: [vmxnet3 network adapter](https://sqladm.blogspot.com/2019/03/vmxnet3-network-adapter.html)
1) Start VM
1) sysprep
    * Start Windows Shell (CMD):
    * `%WINDIR%\system32\sysprep\sysprep.exe /generalize /shutdown /oobe`
    * (see above)
1) Start VM
1) Configure computer on first start
    * Region: United States
    * Language: English (United States)
    * Keyboard: Danish
    * Create local user
        * Name: LocalNiels
        * Password: Bacon123
        * Security questions and answers to your personal preference ;-)
    * Activity History: No
    * Digital Assistant: Decline
    * Privacy setting: Disable all
1) Check that Windows is activated
1) Rename computer
    * Start PowerShell as administrator:
    * `Rename-Computer -NewName 'PAM00' -Restart`
    * Computer will restart
1) Configure vmxnet3 Ethernet Adapter
    * Power Management: Disable "Allow computer to turn off device to save power"
    * Rename adapter "Ethernet42"
1) Configure Internet Protocol Version 4 properties to static network definition
    * Start PowerShell as administrator:
    * `Get-NetIPInterface -AddressFamily IPv4`
    * Note ifIndex of InterfaceAlias Ethernet42 (here it is 6)
    * `Set-NetIPInterface -InterfaceIndex 6 -Dhcp Disabled`
    * `New-NetIPAddress -InterfaceIndex 6 -AddressFamily IPv4 -IPAddress '192.168.42.20' -PrefixLength 24`
    * This must be done after changing network adapter as the configuration is assigned the adapter
1) Configure DNS
    * Primary DNS (IP): 192.168.42.10 (this host)
    * Secondary DNS (IP): 192.168.42.1 (the vmnet)
    * Subnet Mask: 255.255.255.0
    * Default Gateway (IP): None (host-only)
    * `Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses ('192.168.42.10','192.168.42.1') -PassThru`
1) Check network configuration
    * `ipconfig -all`
1) Change time zone to UTC
1) Add computer to AD
    * `Add-Computer -DomainName 'SQLBACON' -Restart`
    * Enter credentials on SuperNiels (see DC configuration)
    * Computer will restart