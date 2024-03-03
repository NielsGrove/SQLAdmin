<#
.DESCRIPTION
  Functionality for SQLAnchor.
#>

Add-Type -AssemblyName System.Windows.Forms

function Get-UserInfo {}

#region Main Window

function New-MainWindow {
<#
.DESCRIPTION
  Create the main window for SQLAnchor.
#>
[CmdletBinding()]
[OutputType([void])]
Param()

Begin {
  # Check if there are bits left from another SQLAnchor main window.
}

Process {
  $MainForm = New-Object -TypeName System.Windows.Forms.Form
  $MainForm.StartPosition = 'CenterScreen'
  $MainForm.Text = 'SQLAnchor'

  $MainForm.ShowDialog()
}

End {}
}  # New-MainWindow

#endregion Main Window
