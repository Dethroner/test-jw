param ([String] $PlainPassword, [String] $FQDN, [String] $NetBIOS)

$subnet = 10.50.10.100 -replace "\.\d+$", ""

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Install DNS server"
Install-WindowsFeature DNS -IncludeManagementTools
# Add-DnsServerPrimaryZone -NetworkID 10.50.10.0/24 -ZoneFile "10.50.10.10.in-addr.arpa.dns"
# Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing RSAT tools"
Import-Module ServerManager
Add-WindowsFeature RSAT-AD-PowerShell,RSAT-AD-AdminCenter

# Disable password complexity policy
secedit /export /cfg C:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
rm -force C:\secpol.cfg -confirm:$false

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating domain controller"
$SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force
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

$newDNSServers = "127.0.0.1", "8.8.8.8", "4.4.4.4"

  $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -And ($_.IPAddress).StartsWith($subnet) }
  if ($adapters) {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Setting DNS"
    $adapters | ForEach-Object {if (!($_.Description).Contains("Hyper-V")) {$_.SetDNSServerSearchOrder($newDNSServers)}}
  }

 #Get-DnsServerResourceRecord -ZoneName $FQDN -type 1 -Name "@" |Select-Object HostName,RecordType -ExpandProperty RecordData |Where-Object {$_.IPv4Address -ilike "10.*"}|Remove-DnsServerResourceRecord
 $RRs= Get-DnsServerResourceRecord -ZoneName $FQDN -type 1 -Name "@"

 foreach($RR in $RRs)
 {
  if ( (Select-Object  -InputObject $RR HostName,RecordType -ExpandProperty RecordData).IPv4Address -ilike "10.50.*")
  {
   Remove-DnsServerResourceRecord -ZoneName $FQDN -RRType A -Name "@" -RecordData $RR.RecordData.IPv4Address -Confirm
  }

 }
Restart-Service DNS
