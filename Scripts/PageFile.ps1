<#
.DESCRIPTION
  Configure Windows pagefile. Typically on windows server.
  On dedicated local drive.

  The page file size formula should be:
    (Max value of Committed Bytes + additional 20% buffer to accommodate any workload bursts)-RAM size
  For example: If the server has 24 GB RAM and the maximum of Committed Bytes is 26 GB, 
  then the recommended page file will be: (26*1.2)-24)  = 7.2 GB
.LINKS
  Microsoft Support: How to determine the appropriate page file size for 64-bit versions of Windows
  <https://support.microsoft.com/en-us/help/2860880/how-to-determine-the-appropriate-page-file-size-for-64-bit-versions-of>
.LINKS
  Microsoft TechNet blog: Page File � The definitive guide
  <https://blogs.technet.microsoft.com/motiba/2015/10/15/page-file-the-definitive-guide/>
#>

#<#
$PageFile = Get-WmiObject -Class Win32_ComputerSystem -EnableAllPrivileges
$PageFile.AutomaticManagedPagefile = $false
$PageFile.put() | Out-Null
#>
$PageFile = $null


$PhysicalMemory = Get-CimInstance -ClassName Win32_PhysicalMemory
[int]$PageFileSize = 0
foreach ( $Device in $PhysicalMemory ) { $PageFileSize += $Device.Capacity/1MB }
$PageFileSize += 257
"Setting PageFile size to $PageFileSize MB..."

#<#
$PageFileSet = Get-WmiObject -Class Win32_PageFileSetting
$PageFileSet | fl *
$PageFileSet.InitialSize = $PageFileSize
$PageFileSet.MaximumSize = $PageFileSize
$PageFileSet.Name = 'P:\pagefile.sys'
$PageFileSet.Put() | Out-Null
#>
$PageFileSet = $null

$defaultPageFile = Get-WmiObject -Query "SELECT * FROM Win32_PageFileSetting WHERE Name = 'C:\\pagefile.sys'"
#$defaultPageFile | fl *
$defaultPageFile.Delete()
