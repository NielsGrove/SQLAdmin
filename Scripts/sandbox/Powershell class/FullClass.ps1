<#
.DESCRIPTION
  Experiment on Powershell class(es) with full definition.
#>

#Requires -Version 7
Set-StrictMode -Version Latest

#region Full
class Full {
    static [double]$FullAnswer = 42.001
  
    hidden [int]$Rounds
    [string]$Name
    [string]$CallSign
    [int]$Answer = 42
  
    static [string]All() { return 'Gaia' }
    static [double]nPi([int]$n) { return [System.Math]::PI * $n }
  
    Full() {}
    Full([string]$Name, [string]$CallSign) {
      $this.Name = $Name
      $this.CallSign = $CallSign
    }
    Dispose() {
      
    }
  
    [int]Length() {
      return $this.Name.Length + $this.CallSign.Length
    }
  
    [string]ToString() {
      return $this.Name + ' ' + $this.CallSign
    }
    [string]ToString([bool]$NameFirst) {
      if ($NameFirst) { return $this.CallSign + ' ' + $this.Name }
      else { return $this.Name + ' ' + $this.CallSign }
    }
  
    [int]TheAnswer([int]$Count) {
      'Full.TheAswer()' | Write-Output  # Does not show
      return $this.Answer * $Count
    }
  }
  
  function Invoke-FullExample {
  [CmdletBinding()]
  [OutputType([void])]
  Param()
  
  Process {
    '***  Static  ***'
    [Full]::FullAnswer
    [Full]::All()
    [Full]::nPi(3)
  
    "`n***  Full 1  ***"
    $Full1 = [Full]::new()
    $Full1.Name = 'Joe'
    $Full1.CallSign = 'McDonald'
    'Full 1 . Length' + $Full1.Length()
    $Full1.ToString()
    $Full1.ToString('CallSign')
  
    "`n***  Full 2  ***"
    $Full2 = New-Object Full
    $Full2.Name = 'Charles'
    $Full2.CallSign = 'Beagle'
    $Full2.ToString()
    $Full2.TheAnswer(123)
  
    "`n***  Full 3  ***"
    [Full]$Full3 = [Full]::new('Jack', 'Apple')
    $Full3.ToString()
  }
  }  # Invoke-FullExample
  
  Invoke-FullExample
  #endregion Full
