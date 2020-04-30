# Database Servers

## General setup

### Clone VM

Full Clone

### Pre-configuration

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
1) Shut down VM: `shutdown.exe /s`

### Configuration

1) Configure VM
    * CPU: 4 vSockets each 1 vCore
    * Memory: 8 GiB
    * Network: VMnet13
1) Configure vmxnet3 paravirtualized network
1) Start VM
1) sysprep
1) Start VM
1) Configure network: IP
1) Add computer to AD
1) Create service accounts for database instance and SQL Agent (gMSA)
1) Install SQL Server: Database Engine
1) Install latest SQL Server CU
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
