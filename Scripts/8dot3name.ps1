<#
.DESCRIPTION
  Get 8.3 name on given directory.

  Do not use COM components like Scripting.FileSystemObject.
  A cleaner solution using Windows API.
#>

#Requires -Version 7
Set-StrictMode -Version Latest

function Get-ShortPath {
<#
.DESCRIPTION
  Get short (8.3) name on given object.
#>
[CmdletBinding()]
[OutputType([string])]
Param(
  [Parameter(Mandatory=$true,
             ParameterSetName='Dir',
             ValueFromPipeLine=$true,
             HelpMessage='Take your time to write a good help message...')]
  [ValidateScript({Test-Path -LiteralPath $_})]
  [System.IO.DirectoryInfo]$Directory,
  [Parameter(Mandatory=$true,
             ParameterSetName='File',
             ValueFromPipeline=$true,
             HelpMessage='File name with full path.')]
  [ValidateScript({Test-Path -LiteralPath $_})]
  [System.IO.FileInfo]$File
)

Process {
  'ParameterSetName: ' + $PSCmdlet.ParameterSetName | Write-Debug

  $Signature = '[DllImport("kernel32.dll", SetLastError=true)]
  public static extern int GetShortPathName(String pathName, StringBuilder shortName, int cbShortName);'
  Add-Type -MemberDefinition $Signature -Namespace Tools -Name Path -UsingNamespace System.Text -Verbose:$false
  
  [Int32]$NameLength = -1
  [string]$NameString = ''
  switch ($PSCmdlet.ParameterSetName) {
    'Dir' {
      $NameLength = $Directory.ToString().Length
      $NameString = $Directory.ToString()
    }
    'File' {
      $NameLength = $File.ToString().Length
      $NameString = $File.ToString()
    }
    Default {}
  }

  $StringBuilder = [System.Text.StringBuilder]::new($NameLength)
  [int]$Return = 0
  switch ($PSCmdlet.ParameterSetName) {
    'Dir' { $Return = [Tools.Path]::GetShortPathName($Directory.FullName, $StringBuilder, $NameLength) }
    'File' { $Return = [Tools.Path]::GetShortPathName($File.FullName, $StringBuilder, $NameLength) }
    Default {}
  }

  [string]$ShortPath = $null
  if ($Return -ne 0) {
    $ShortPath = $StringBuilder.ToString()
  }
  else {
    "Could not convert '$NameString' to short name." | Write-Warning
  }
  return $ShortPath
}

}  # Get-ShortPath


'Examples...'
Get-ShortPath -Directory 'C:\Program Files\Microsoft SQL Server\150\' -Verbose -Debug
Get-ShortPath -File 'C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE' -Verbose -Debug
