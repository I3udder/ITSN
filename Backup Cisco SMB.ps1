# Install-Module Posh-SSH first time use required

$session = New-SSHSession -ComputerName "192.168.32.17" -Credential (Get-Credential)
$stream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
$stream.Write("copy run scp://cisco:cisco@172.16.50.101/itsnasw10-24082017.conf`n")