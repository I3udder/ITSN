# Install-Module Posh-SSH first time use required
# Cisco SMB command ip ssh password-auth must be entered in the comfiguration of the device. If the device doesn't support the command the device needs to be upgraded to a later version of the firmware.
# Minimal Powershell Version 3
# (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
# iex (New-Object Net.WebClient).DownloadString("https://gist.github.com/darkoperator/6152630/raw/c67de4f7cd780ba367cccbc2593f38d18ce6df89/instposhsshdev")

$time = get-date -format yyyyMMdd-HHmmss 
$session = New-SSHSession -ComputerName "192.168.32.17" -Credential (Get-Credential)
$stream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$stream.Write("copy run scp://cisco:cisco@172.16.50.101/itsnveasw10-" + $time + ".conf`n")
Remove-SSHSession $session