# Database Servers

## General Configuration

1) Clone VM
1) Configure VM
    * CPU: 4 vSockets each 1 vCore
    * Memory: 8 GiB
    * Network: VMnet13
1) Configure vmxnet paravirtualized network
1) Add disks for data, translog, tempdb and backup
    * Paravirtulized
    * GPT partition
    * ReFS format with 64 KB Allocation Unit
1) sysprep
1) Configure network: IP
1) Add computer to AD
1) Create service accounts for database instance and SQL Agent (gMSA)
1) Install SQL Server: Database Engine
1) Install latest SQL Server CU
1) Configure backup (OHMS)

Addition configurations to add later:

* Storage: Different disks for SQL Server data, translog and backup

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

