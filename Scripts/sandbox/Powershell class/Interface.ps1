<#
.DESCRIPTION
  Example on PowerShell class interface
#>

public interface IExample {
  void TheClass()  # ERROR:  An expression was expected after '('.
}

class AClass : IExample {
  [int]$Year

  AClass() {}
}


$Class0 = [AClass]::new()
$Class0.Year = 1972
