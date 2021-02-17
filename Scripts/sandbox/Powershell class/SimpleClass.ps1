<#
.DESCRIPTION
  Simple experiment on Powershell class(es)
#>

#Requires -Version 7
Set-StrictMode -Version Latest


#region Simple
class Simple {
  [string]$Name
  [string]$CallSign
  [int]$Age
}

$Simple1 = [Simple]::new()
$Simple1.Name = 'Joe'
$Simple1.CallSign = 'Average'
$Simple1.Age = 42

$Simple1 | Format-Table

$Simple2 = New-Object -TypeName Simple
$Simple2.Name = 'McDonald'
$Simple2.CallSign = 'Old'
$Simple2.Age = 123

$Simple2 | Format-Table *
#endregion Simple
