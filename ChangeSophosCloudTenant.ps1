$path = "\\netapp01\Sophos\$Env:computername.log"
$token = "c75c112cef4a1dbf79382e1a7e2cb6cbf00f7e4453055dea9a420a68f90c67c0"
$server = "https://dzr-mcs-amzn-eu-west-1-9af7.upe.p.hmr.sophos.com/sophos/management/ep"
$configfile = 'd:\temp\config.xml'
$registrationfile = 'd:\temp\registration.txt'

# Start logging client operations
Start-Transcript -Path $path -NoClobber
# Stop the Sophos MCS Client service
Stop-Service "Sophos MCS Client"
#Remove obsolete items
Remove-Item -Path "C:\ProgramData\Sophos\Management Communications System\Endpoint\Persist\Credentials" -Force
Remove-Item -Path "C:\ProgramData\Sophos\Management Communications System\Endpoint\Persist\EndpointIdentity.txt" -Force
Remove-Item -Path "C:\ProgramData\Sophos\Management Communications System\Endpoint\Persist\*" -Include *.xml -Force
Remove-Item -Path "C:\ProgramData\Sophos\AutoUpdate\data\machine_ID.txt" -Force
#Replace config.xml and registration.txt
Remove-Item -Path "C:\ProgramData\Sophos\Management Communications System\Endpoint\Config\Config.xml" -Force
Remove-Item -Path "C:\ProgramData\Sophos\Management Communications System\Endpoint\Config\registration.txt" -Force

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

#Copy-Item -Path "\\netapp01\ftp\sophos\Config.xml" -Destination "C:\ProgramData\Sophos\Management Communications System\Endpoint\Config" -Force
#Copy-Item -Path "\\netapp01\ftp\sophos\registration.txt" -Destination "C:\ProgramData\Sophos\Management Communications System\Endpoint\Config" -Force
# Start the Sophos MCS Client service
Start-Service "Sophos MCS Client"
#Stop logging client operations
Stop-Transcript