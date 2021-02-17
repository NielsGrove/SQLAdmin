
#region Main-Detail
class Detail {
    [string]$DetailName
  }
  
  class Main {
    [string]$MainName
    [Detail]$Detail = [Detail]::new()
  }
  
  $Main1 = [Main]::new()
  $Main1.MainName = 'Beagle'
  $Main1.Detail.DetailName = 'Charles'
  
  #$Main1 |Format-Table
  #endregion Main-Detail
  