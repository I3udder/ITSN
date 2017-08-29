# Install-Module Posh-SSH first time use required
# Cisco SMB command ip ssh password-auth must be entered in the comfiguration of the device. If the device doesn't support the command the device needs to be upgraded to a later version of the firmware.
# Minimal Powershell Version 3
# (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
# iex (New-Object Net.WebClient).DownloadString("https://gist.github.com/darkoperator/6152630/raw/c67de4f7cd780ba367cccbc2593f38d18ce6df89/instposhsshdev")
# Added Logging via Transcript and auto install Posh-SSH

$Switches = Import-Csv sample.csv
$time = get-date -format yyyyMMdd-HHmmss
$path = "C:\<Backup DIR>\Switch-Backup-" + $time + ".txt"
Start-Transcript -Path $path -NoClobber

import-module Posh-SSH

If ( ! (Get-module Posh-SSH )) { 
  If ( ! (Get-Module PsGet)) {
   Invoke-Expression (New-Object Net.WebClient).DownloadString("https://gist.github.com/darkoperator/6152630/raw/c67de4f7cd780ba367cccbc2593f38d18ce6df89/instposhsshdev")
   }
  else {
    Install-Module Posh-SSH
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
Remove-SSHSession $session

$Output = "Backup of "+ $Switch.hostname +" Finished"
Write-Output $Output
}
Stop-Transcript 