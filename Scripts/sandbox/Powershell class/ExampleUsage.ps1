<#
.DESCRIPTION
  Use class defined in Example.class.ps1.
#>

. $PSScriptRoot\Example.class.ps1

$Example1 = New-Object -TypeName Example

$Example1.Name = 'Mickey'
$Example1.Year = 1998

$Example1 | Format-Table


$Example2 = [Example]::new('Goofy')
$Example2.Year = 1987

$Example2 | Format-Table


$Example3 = New-Object -TypeName Example -ArgumentList 'Uncle', 1789

$Example3 | Format-Table
