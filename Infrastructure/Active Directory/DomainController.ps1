<#
.DESCRIPTION
  Create Active Directory (AD) Domain Controller (DC) with new domain in new forrest.

  Windows Server 2016 - later Windows Server 2016 Core (1709) or Windows Server 2019 Core
.LINK
  How to build a server 2016 domain controller (Non-GUI) and make it secure
  (https://medium.com/@rootsecdev/how-to-build-a-server-2016-domain-controller-non-gui-and-make-it-secure-4e784b393bac)
.LINK
  Step-By-Step: Setting up Active Directory in Windows Server 2016
  (https://blogs.technet.microsoft.com/canitpro/2017/02/22/step-by-step-setting-up-active-directory-in-windows-server-2016/)
#>

#region Server
# Change adapter to vmxnet3


###  Configure server with "sconfig"  ###

# 1) Create computer name (option 2)
#    (https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/rename-computer?view=powershell-5.1)
Rename-Computer -NewName 'DC00' -Restart

# 2) Configure static IP address (option 8)
#    (https://docs.microsoft.com/en-us/powershell/module/nettcpip/set-netipaddress?view=win10-ps)
Set-NetIPAddress -InterfaceIndex ... -IPAddress 192.168.42.42
# Win32_NetworkAdapterConfiguration class  (https://msdn.microsoft.com/en-us/library/aa394217.aspx)  (https://blogs.technet.microsoft.com/heyscriptingguy/2012/02/28/use-powershell-to-configure-static-ip-and-dns-settings/)
Win32_NetworkAdapterConfiguration

# 3) Set date and time (option 9)

# 4) Windows Location: UK - UTC

# 5) Time format: UK ISO 8601'ish

# 6) Windows SmartScreen: Enabled

# Exit to command line (option 15)
#endregion Server


#region Domain Controller
# Start PowerShell as Administrator: "powershell.exe"

# Create Domain Controller
Get-WindowsFeature AD-Domain-Services | Install-WindowsFeature

# ToDo: Alternative placement of NTDS files, e.g D-drive

Import-Module ADDSDeployment 
Install-ADDSForest
# ignore warnings...

# Create Domain Admin user
New-ADUser -Name 'SuperNiels' -GivenName '' -Surname '' -SamAccountName superniels -UserPrincipalName superniels@sqladmin.lan
Get-ADUser SuperNiels

# Set password for Domain Admin user
Set-ADAccountPassword 'CN=SuperNiels,CN=users,DC=sqladmin,DC=lan' -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'P@ssword1234' -Force)
Enable-ADAccount -Identity SuperNiels

# Add user to Domain Admins
Add-ADGroupMember 'Domain Admins' SuperNiels

#endregion Domain Controller
