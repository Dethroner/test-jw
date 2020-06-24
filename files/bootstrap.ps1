param ([String] $PlainPassword, [String] $FQDN, [String] $NetBIOS)

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Install DNS server"
Install-WindowsFeature DNS -IncludeManagementTools
Add-DnsServerPrimaryZone -NetworkID 10.50.10.0/24 -ZoneFile "10.50.10.10.in-addr.arpa.dns"
Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing RSAT tools"
Import-Module ServerManager
Add-WindowsFeature RSAT-AD-PowerShell,RSAT-AD-AdminCenter

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating domain controller"
# Disable password complexity policy
secedit /export /cfg C:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
rm -force C:\secpol.cfg -confirm:$false

$SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) $PlainPassword to $SecurePassword"

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest `
    -SafeModeAdministratorPassword $SecurePassword `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "Win2012" `
    -DomainName $FQDN `
    -DomainNetbiosName $NetBIOS `
    -ForestMode "Win2012" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true
#
# Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Reboot server..."
# Restart-Computer