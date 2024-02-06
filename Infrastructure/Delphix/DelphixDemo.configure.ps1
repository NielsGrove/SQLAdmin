<#
.DESCRIPTION
  Change Delhix disk from growable to preallocated.

.NOTES
  2017-09-27 (NGR) Script file created when importing Delphix vm - DOES NOT WORK.
#>

Set-Location -LiteralPath 'C:\Program Files (x86)\VMware\VMware Workstation'
[System.IO.FileInfo]$VmPath = 'C:\NgrAdmin\VirtualMachines\Delphix00'
if ($VmPath.CreationTimeUtc -gt '1967-01-01') { "OK - Path '$($VmPath.DirectoryName)' exists." }


"{0:s}Z  Import Delphix ova-file..." -f [System.DateTime]::UtcNow


"{0:s}Z  Convert virtual disk for system from growable to preallocated..." -f [System.DateTime]::UtcNow
.\vmware-vdiskmanager.exe -r 'C:\NgrAdmin\VirtualMachines\Delphix00\Delphix00-disk1.vmdk' -s 300GB 'C:\NgrAdmin\VirtualMachines\Delphix00\Delphix00.System00.vmdk' -t 2

"{0:s}Z  Add data disks to Delphix..." -f [System.DateTime]::UtcNow
$DisksWatch = [System.Diagnostics.Stopwatch]::StartNew()
[int[]]$DiskNos = 0..3
foreach ($DiskNo in $DiskNos) {
  "{0:s}Z  Adding disk $DiskNo..." -f [System.DateTime]::UtcNow
  $DiskWatch = [System.Diagnostics.Stopwatch]::StartNew()

  [string]$FullFileName = "$($VmPath.FullName)\Delphix00.Data0$DiskNo.vmdk"
  .\vmware-vdiskmanager.exe $FullFileName -c -a 'scsi' -s 20GB -t 2

  $DiskWatch.Stop()
  "{0:s}Z  Disk $DiskNo created with success (duration = $($DiskWatch.Elapsed.ToString()). [hh:mm:ss.ddd])."
}
$DisksWatch.Stop()
"{0:s}Z  Data disks created with success (duration = $($DisksWatch.Elapsed.ToString()). [hh:mm:ss.ddd])."
