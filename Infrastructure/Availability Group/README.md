
# SQL Server AlwaysOn Availability Group Sandbox

Build a Availability Group sandbox with three replica. One Primary replica, one sync replica and one async replica. The sandbox also contain necessary resources and tools.

At first this will be a rather manual process, but it is my intention to automate as much as I can figure out.

The architecture of this sandbox is in the document [Availability Group Sandbox Architecture](Architecture.md).

## Infrastructure

* Active Directory Domain Controller hosting domain.
* Databaseservers, three nodes in domain.
* Witness file server in domain.
* Privileged Access Machine (PAM) workstation in domain.

All computers are virtual running on VMware Workstation Pro. Each computer is based on a full clone of an existing vm that is updated but with minimum configuration.

This sandbox is build on Windows Server 2019 Std Ed, SQL Server 2019 Ent Ed and Windows 10 Pro. Automation is build in PowerShell 5.1 and T-SQL.

Many features only works with PowerShell 5 so PowerShell 7+ is not required and should be omitted from this sandbox.

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

## Active Directory

See document ([link](ActiveDirectory.md)) on building Active Directory (AD) domain with Domain Controller (DC)

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

* Cluster Name: Silicium

## Create Availability Group

* AG Name: 
* Listener Name: 
* Listener IP:
* Sample database: AdventureWorks

1) Configure Quorum Voting
