# Source: https://github.com/StefanScherer/adfs2
param ([String] $newPass)


$box = Get-ItemProperty -Path HKLM:SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName -Name "ComputerName"
$box = $box.ComputerName.ToString().ToLower()

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Setting timezone..."
c:\windows\system32\tzutil.exe /s "Belarus Standard Time"

Write-Host "Checking if Windows evaluation is expiring soon or expired..."
. c:\vagrant\files\fix-windows-expiration.ps1

Write-Host "Disable IPv6 on all network adatpers..."
Get-NetAdapterBinding -ComponentID ms_tcpip6 | ForEach-Object {Disable-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6}
Get-NetAdapterBinding -ComponentID ms_tcpip6 
# https://support.microsoft.com/en-gb/help/929852/guidance-for-configuring-ipv6-in-windows-for-advanced-users
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f

Write-Host "Rename Administrator to admin & Enable..."
Set-LocalUser -Name "Administrator" -PasswordNeverExpires $true
Rename-LocalUser -Name "Administrator" -NewName "admin"
net user admin $newPass
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "admin"

# Disable-LocalUser -Name  "vagrant"

# Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\‘ -Name "fDenyTSConnections" -Value 0
# Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\‘ -Name "UserAuthentication" -Value 1
# Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
