<#
.DESCRIPTION
  Modal MessageBox
#>

Clear-Host

Add-Type -AssemblyName System.Windows.Forms

#$Owner = New-Object Windows.Forms.Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
#[System.Windows.Forms.MessageBox]::Show($([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle), 'Please read marked text on the console!', 'MsSql Install', $([Windows.Forms.MessageBosButtons]::'OK', 'Warning') | Out-Null

# New-Object : Cannot find type [Win32Window]: verify that the assembly containing this type is loaded.

[System.Windows.Forms.IWin32Window]$Owner = New-Object Win32Window ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle.ToString())
$Owner | gm

$Text = [System.String]'Please read marked text on the console!'
$Caption = [System.String]'MsSql Install'
$Buttons = [System.Windows.Forms.MessageBoxButtons]::OK
$Icon = [System.Windows.Forms.MessageBoxIcon]::Warning

#[System.Windows.Forms.MessageBox]::Show($Owner, $Text) | Out-Null
#[System.Windows.Forms.MessageBox]::Show($Owner, $Text, $Caption, $Buttons, $Icon) | Out-Null
