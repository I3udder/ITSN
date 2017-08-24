# Install-Module Posh-SSH first time use required
# command ip ssh password-auth must be entered in the comfiguration of the device. If the device doesn't support the command the device needs to be upgraded to a later version of the firmware.

$time = get-date -format yyyyMMdd-HHmmss 
$session = New-SSHSession -ComputerName "192.168.32.17" -Credential (Get-Credential)
$stream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$stream.Write("copy run scp://cisco:cisco@172.16.50.101/itsnveasw10-" + $time + ".conf`n")