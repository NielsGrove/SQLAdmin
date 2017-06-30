
'!!  Test Logging functions...'
Start-Log -LogFileName 'SqlAdminTest' #-Verbose #-Debug
'Hello to text file.' | Write-Log #-Verbose #-Debug
Stop-Log #-Verbose #-Debug

'!!  Test '
#Get-SqlAdminComputer -Verbose -Debug





#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#
<#
Describe "Get-Function" {
	Context "Function Exists" {
		It "Should Return" {
		
		}
	}
}
#>
