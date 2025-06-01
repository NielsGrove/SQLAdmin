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
