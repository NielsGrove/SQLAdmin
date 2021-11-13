<#
.DESCRIPTION
  Get 8.3 name on given directory.

  Do not use COM components like Scripting.FileSystemObject.
  A cleaner solution using Windows API.

.LINK
  Idera Community: Converting File Paths to 8.3 (Part 2)
  (https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/converting-file-paths-to-8-3-part-2)
#>

#Requires -Version 5
Set-StrictMode -Version Latest


function Get-ShortPath {
<#
.DESCRIPTION
  Get short (8.3) name on given object.
#>
[CmdletBinding()]
[OutputType([string])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true, HelpMessage='Take your time to write a good help message...')]
  [System.IO.DirectoryInfo]$Directory
)

Process {
  $Signature = '[DllImport("kernel32.dll", SetLastError=true)]
  public static extern int GetShortPathName(String pathName, StringBuilder shortName, int cbShortName);'

  $Type = Add-Type -MemberDefinition $Signature -Namespace Tools -Name Path -UsingNamespace System.Text
  
  [uint]$NameLength = 300
  $StringBuilder = [System.Text.StringBuilder]::new($NameLength)
  [int]$Return = [Tools.Path]::GetShortPathName($Directory.FullName, $StringBuilder, $NameLength)

  [string]$ShortPath = $null
  if ($Return -ne 0) {
    $ShortPath = $StringBuilder.ToString()
  }
  else {
    "Could not convert $($Directory.FullName)." | Write-Warning
  }
  return $ShortPath
}

}  # Get-ShortPath


Get-ShortPath -Directory 'C:\Program Files\Microsoft SQL Server\150\' -Verbose -Debug
