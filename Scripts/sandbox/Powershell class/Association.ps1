<#
.DESCRIPTION
  Examples of association of two custom PowerShell classes.
  The first example is with a 1:1 association.
  The second example is with a 1:* association.
#>

# 1:1
class Detail {
  [string]$Name
}

class Main {
  [string]$Name
  [Detail]$Detail = [Detail]::new()
}


$Main1 = [Main]::new()
$Main1.Name = 'Beagle'
$Main1.Detail.Name = 'Charles'

$Main1 |Format-List


# 1:*

class Wheel {
  [int]$Diameter

  Wheel() {}

  Wheel([int]$Diameter) {
    $this.Diameter = $Diameter
  }
}

class Vehicle {
  [string]$Color
  [Wheel[]]$Wheels

  Vehicle() {}

  [void]AddWheel() {
    $this.Wheels += [Wheel]::new()
  }
  [void]AddWheel([int]$Diameter) {
    $this.Wheels += [Wheel]::new($Diameter)
  }
}


$Vehicle1 = New-Object -TypeName Vehicle
$Vehicle1.Color = 'Orange'
$Vehicle1.AddWheel()
$Vehicle1.AddWheel(18)

'The Vehicle has ' + $Vehicle1.Wheels.Count + ' wheels.'
'Wheel 0 diameter is ' + $Vehicle1.Wheels[0].Diameter
'Wheel 1 diameter is ' + $Vehicle1.Wheels[1].Diameter
