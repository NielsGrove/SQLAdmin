<#
.DESCRIPTION
  Definition of a class.
  Imported in script file by dot-sourcing like in ExampleUsage.ps1
#>

class Example {
  [string]$Name
  [int]$Year
  
  Example() {}

  Example([string]$Name) {
    $this.Name = $Name
  }

  Example([string]$Name, [int]$Year) {
    $this.Name = $Name
    $this.Year = $Year
  }

  [int]GetAge() {
    return (Get-Date).Year - $this.Year
  }
}
