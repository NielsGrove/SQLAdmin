<#
.DESCRIPTION
  Check Delphix OVA-file by MD5 hash value also provide by Delphix
.NOTES
  2017-10-20 (NGR) Script file created

.LINK
  Microsoft Docs: Get-FileHash
  (https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash)
#>

#Requires -Version 5
Set-StrictMode -Version Latest


function Test-DelphixFile {
<#
.DESCRIPTION
  Check MD5 on Delphix file and compare with reference.
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  Microsoft Docs: FileInfo Class
  (https://docs.microsoft.com/da-dk/dotnet/api/system.io.fileinfo)
.NOTES
  2017-01-23 (NGR) Function created to check multiple Delphix files.
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [System.IO.FileInfo]$DelphixFile,

  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [System.IO.FileInfo]$DelphixMD5
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Test-DelphixFile( '$($DelphixFile.FullName)', '$DelphixMD5' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  'Calculating MD5 hash on file...' | Write-Verbose
  [string]$DelphixFileMD5 = (Get-FileHash -LiteralPath $DelphixFile.FullName -Algorithm MD5).Hash

  if ($DelphixFileMD5 -eq $DelphixMD5) {
    'OK'
  }
  else {
    "'$DelphixFileMD5' is not correct!" | Write-Error
  }
}

End {
  $mywatch.Stop()
  [string]$Message = "Test-DelphixFile finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Test-DelphixFile()


###  Invoke  ###
[System.IO.FileInfo]$DelphixFolder = 'C:\NgrAdmin\DML\Delphix'

#<#
[System.IO.FileInfo]$DelphixFile = $DelphixFolder.FullName + '\Delphix_5.1.8.1_2017-09-13-05-40_HWv8_Demo.ova'
[string]$DelphixMD5 = 'b91499bdd24461905aa89642d8b0b074'
#>
<#
[System.IO.FileInfo]$DelphixFile = $DelphixFolder.FullName + '\delphix_5.1.8.1_2017-09-13-05-40.upgrade.tar.gz'
[string]$DelphixMD5 = 'f63022917bc76bcaaca2fbeccc652512'
#>

Test-DelphixFile -DelphixFile $DelphixFile -DelphixMD5 $DelphixMD5 -Verbose #-Debug
