# Cisco SMB command ip ssh password-auth must be entered in the comfiguration of the device. If the device doesn't support the command the device needs to be upgraded to a later version of the firmware.
# Minimal Powershell Version 3
# Added Logging via Transcript and auto install Posh-SSH

$Switches = Import-Csv sample.csv
$time = get-date -format yyyyMMdd-HHmmss
$path = "C:\<Backup DIR>\Switch-Backup-" + $time + ".txt"
Start-Transcript -Path $path -NoClobber

import-module Posh-SSH
import-module PsGet

If ( ! (Get-module Posh-SSH )) { 
  If ( ! (Get-Module PowerShellGet) -Or ! (Get-Module PsGet)) {
   Invoke-Expression (New-Object Net.WebClient).DownloadString("https://gist.github.com/darkoperator/6152630/raw/c67de4f7cd780ba367cccbc2593f38d18ce6df89/instposhsshdev")
   }
  else {
    Find-Module Posh-SSH | Install-Module
   }

}

ForEach ($Switch in $Switches) {

$Output = "Backup of "+ $Switch.hostname +" Started"
Write-Output $Output

$password = convertto-securestring -String $Switch.pass -AsPlainText -force
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $Switch.user,$password

$session = New-SSHSession -ComputerName $Switch.ipaddress -Credential $credentials -AcceptKey
$stream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$stream.Write("copy run scp://"+ $Switch.scpuser +":"+ $Switch.scppass +"@<Host FQDN or IP>/"+ $Switch.hostname  +"-" + $time + ".conf`n")
#Cisco Catalyst Switches require 3 enters
Start-Sleep -s 5
$stream.Write("`n")
Start-Sleep -s 5
$stream.Write("`n")
Start-Sleep -s 5
$stream.Write("`n")
Start-Sleep -s 30
Remove-SSHSession $session | Out-Null

$Output = "Backup of "+ $Switch.hostname +" Finished"
Write-Output $Output
}
Stop-Transcript 