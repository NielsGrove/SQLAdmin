<#
.DESCRIPTION
  Example on setting up a (local) Windows Storage Space on 5 SAS SSD drives in Windows Server 2016.
  In the Storage Space are then defined 2 ReFS Virtual Disks with different size and allocation unit size.
#>

'Create Windows Storage Pool...'
New-StoragePool -FriendlyName Pool_00 -StorageSubSystemFriendlyName (Get-StorageSubSystem).FriendlyName -PhysicalDisks (Get-PhysicalDisk -CanPool $true) -LogicalSectorSizeDefault 4096

'Create Virtual Disk...'
New-VirtualDisk -StoragePoolFriendlyName Pool_00 -FriendlyName ProgramDisk -ResiliencySettingName Mirror -NumberOfDataCopies 3 -Size (42GB) -ProvisioningType Thin

'Create partition and format volume...'
Get-VirtualDisk -FriendlyName ProgramDisk | Get-Disk |
Initialize-Disk -PartitionStyle GPT -PassThru |
New-Partition -DriveLetter F -UseMaximumSize |
Format-Volume -NewFileSystemLabel Program -FileSystem ReFS

'Check volume...' 
.\fsutil.exe fsinfo refsinfo F:


'Create Virtual Disk...'
New-VirtualDisk -StoragePoolFriendlyName Pool_00 -FriendlyName DataDisk -ResiliencySettingName Mirror -NumberOfDataCopies 3 -Size (123GB) -ProvisioningType Thin

'Create partition and format volume...'
Get-VirtualDisk -FriendlyName DataDisk | Get-Disk |
Initialize-Disk -PartitionStyle GPT -PassThru |
New-Partition -DriveLetter H -UseMaximumSize |
Format-Volume -NewFileSystemLabel Data -FileSystem ReFS -AllocationUnitSize 64KB

'Check volume...'
.\fsutil.exe fsinfo refsinfo H:
