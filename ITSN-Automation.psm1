#ITSN Powershell Module for automation
#Changelog 
#12-04-2018 : JVE : Added Set-SophosTenant to move AV client to another Tenant within the Sophos Cloud console.
#12-04-2018 : JVE : Added Get-CiscoBackup to create a cli backup via SSH and put it op an SCP location.

function Set-SophosTenant {

<#
  .SYNOPSIS
  This function changes the Sophos Cloud tenant
  .DESCRIPTION
  This function changes the Sophos Cloud tenant. 
  .NOTES
  It is mandatory that Tamper Protection is disabled on the client.
  .PARAMETER token
  The Sophos token is presented the first time you install a client. You need to extract this from a client.
  .PARAMETER server
  The Sophos server used can be found in the cloud console it is also presented the first time you install a client.
  .PARAMETER logpath
  Present a log file to log the steps from this function.
  .PARAMETER configfile
  Present the configfile location and filename where the config file is located. When not used, the default location is presented.
  .PARAMETER registrationfile
  Present the registrationfile location and filename where the config file is located. When not used, the default location is presented.
  #>

      Param (
        [Parameter(Mandatory=$true)]
        [String]$token,        
        [Parameter(Mandatory=$true)]
        [String]$server,
        [Parameter(Mandatory=$true)]
        [String]$logpath,
        [Parameter(Mandatory=$false)]
        [String]$configfile,
        [Parameter(Mandatory=$false)]
        [String]$registrationfile
     )

# If optional value is null then use default location
if (!$configfile) {$configfile = "$env:ProgramData\Sophos\Management Communications System\Endpoint\Config\Config.xml"}
if (!$registrationfile) {$registrationfile = "$env:ProgramData\Sophos\Management Communications System\Endpoint\Config\registration.txt"}

# Start logging client operations
Start-Transcript -Path $logpath -NoClobber
# Stop the Sophos MCS Client service
Stop-Service "Sophos MCS Client"
#Remove obsolete items
Remove-Item -Path "$env:ProgramData\Sophos\Management Communications System\Endpoint\Persist\Credentials" -Force
Remove-Item -Path "$env:ProgramData\Sophos\Management Communications System\Endpoint\Persist\EndpointIdentity.txt" -Force
Remove-Item -Path "$env:ProgramData\Sophos\Management Communications System\Endpoint\Persist\*" -Include *.xml -Force
Remove-Item -Path "$env:ProgramData\Sophos\AutoUpdate\data\machine_ID.txt" -Force
Remove-Item -Path "$env:ProgramData\Sophos\Management Communications System\Endpoint\Config\Config.xml" -Force
Remove-Item -Path "$env:ProgramData\Sophos\Management Communications System\Endpoint\Config\registration.txt" -Force

#Build config.xml file
$Configline1 = '<?xml version="1.0" encoding="UTF-8"?>'
$Configline2 = '<Configuration>'
$Configline3 = '	<McsClient>'
$Configline4 = '		<servers>'
$Configline5 = '			<server>'+ $server + '</server>'
$Configline6 = '		</servers>'
$Configline7 = '		<registrationToken>'+ $token +'</registrationToken>'
$Configline8 = '		<policyChangeServers />'
$Configline9 = '		<proxies />'
$Configline10 = '		<proxyCredentials />'
$Configline11 = '		<useSystemProxy>1</useSystemProxy>'
$Configline12 = '		<useAutomaticProxy>1</useAutomaticProxy>'
$Configline13 = '		<randomSkewFactor>1</randomSkewFactor>'
$Configline14 = '		<commandPollingInterval>60</commandPollingInterval>'
$Configline15 = '		<messageRelays />'
$Configline16 = '		<useDirect>1</useDirect>'
$Configline17 = '	</McsClient>'
$Configline18 = '</Configuration>'

$Configline1 >> $configfile
$Configline2 >> $configfile
$Configline3 >> $configfile
$Configline4 >> $configfile
$Configline5 >> $configfile
$Configline6 >> $configfile
$Configline7 >> $configfile
$Configline8 >> $configfile
$Configline9 >> $configfile
$Configline10 >> $configfile
$Configline11 >> $configfile
$Configline12 >> $configfile
$Configline13 >> $configfile
$Configline14 >> $configfile
$Configline15 >> $configfile
$Configline16 >> $configfile
$Configline17 >> $configfile
$Configline18 >> $configfile

#Build registration.txt file
$Registrationline1 = '[McsClient]'
$Registrationline2 = 'Token='+ $token
$Registrationline3 = 'ClientProdSelect='
$Registrationline4 = 'GroupOnBootstrap='

$Registrationline1 >> $registrationfile
$Registrationline2 >> $registrationfile
$Registrationline3 >> $registrationfile
$Registrationline4 >> $registrationfile

# Start the Sophos MCS Client service
Start-Service "Sophos MCS Client"

#Stop logging client operations
Stop-Transcript

}

function Get-CiscoBackup {

<#
  .SYNOPSIS
  This function creates a backup of a Cisco switch
  .DESCRIPTION
  This function creates a backup of a Cisco switch 
  .NOTES
  It is mandatory that PoshSSH is installed. The Powershell version 3 required.
  #>

      Param (
        [Parameter(Mandatory=$true)]
        [String]$hostname,        
        [Parameter(Mandatory=$true)]
        [String]$ipaddress,
        [Parameter(Mandatory=$true)]
        [String]$logpath,
        [Parameter(Mandatory=$true)]
        [String]$sshuser,
        [Parameter(Mandatory=$true)]
        [String]$sshpass,
        [Parameter(Mandatory=$true)]
        [String]$scpuser,
        [Parameter(Mandatory=$true)]
        [String]$scppass,
        [Parameter(Mandatory=$true)]
        [String]$scphost
 #       [Parameter(Mandatory=$true)]
 #       [ValidateSet("FTP","SCP", IgnoreCase = $False)]
 #       [String]$protocol
     )

$time = get-date -format yyyyMMdd-HHmmss

$path = $logpath+"\Backup-"+$hostname+"-"+$time+".log"
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

$Output = "Backup of "+ $hostname +" Started"
Write-Output $Output

$password = convertto-securestring -String $sshpass -AsPlainText -force
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $sshuser,$password

$session = New-SSHSession -ComputerName $ipaddress -Credential $credentials -AcceptKey
$stream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$stream.Write("copy run scp://"+ $scpuser +":"+ $scppass +"@"+ $scphost +"/"+ $hostname  +"-" + $time + ".conf`n")
#Cisco Catalyst Switches require 3 enters
Start-Sleep -s 5
$stream.Write("`n")
Start-Sleep -s 5
$stream.Write("`n")
Start-Sleep -s 5
$stream.Write("`n")
Start-Sleep -s 30
Remove-SSHSession $session | Out-Null

$Output = "Backup of "+ $hostname +" Finished"
Write-Output $Output

Stop-Transcript
}

function Remove-OldFiles {

<#
  .SYNOPSIS
  This function removes files older then (default 14 days)
  .DESCRIPTION
  This function removes files older then (default 14 days)
  .NOTES
  If no extension is provided all files are deleted.
  #>

      Param (
        [Parameter(Mandatory=$false)]
        [String]$OlderThen,        
        [Parameter(Mandatory=$true)]
        [String]$TargetFolder,
        [Parameter(Mandatory=$true)]
        [String]$logpath,
        [Parameter(Mandatory=$true)]
        [String]$Extension

     )

#----- define parameters -----#
#----- get current date ----#
$Now = Get-Date
$time = get-date -format yyyyMMdd-HHmmss
#----- define LastWriteTime parameter based on $Days ---#
if (!$Days) {$Days = "14"}

$LastWrite = $Now.AddDays(-$Days)


#----- define log file for delete actions
$path = $logpath+"\Backup-Removed-"+$time+".log"

#----- if extension is not define remove all files
if (!$Extension) {$Extension = "*.*"}
Start-Transcript -Path $path -NoClobber
 
#----- get files based on lastwrite filter and specified folder ---#
$Files = Get-Childitem $TargetFolder -Include $Extension -Recurse | Where-Object {$_.LastWriteTime -le "$LastWrite"}
 
foreach ($File in $Files) 
    {
    if ($NULL -ne $File)
        {
		$Output = "Deleting File "+ $File
        Write-Output $Output
        Remove-Item $File.FullName | out-null
        }
    else
        {
		$Output = "No more files to delete!"
        Write-Output $Output
        }
    }

Stop-Transcript


}