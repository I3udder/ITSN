
  $time = get-date -format yyyyMMdd-HHmmss
  $password = convertto-securestring -String "itsn4u" -AsPlainText -force
  $credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist "loginuser",$password

  $session = New-SSHSession -ComputerName 192.168.100.1 -Credential $credentials -AcceptKey
  $stream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
  $stream.Write("rm /home/login/backup/*.* `n")
  $stream.Write("backup.plx -w /home/login/backup/ITSVENWFWL02-" + $time + ".abf`n")

  Start-Sleep -s 5
  $stream.Write("`n")


Get-SCPFolder -ComputerName "192.168.100.1" -Credential $Credentials -RemoteFolder "/home/login/backup" -LocalFolder "c:/temp"


  $password2 = convertto-securestring -String "cisco" -AsPlainText -force
  $credentials2 = new-object -typename System.Management.Automation.PSCredential -argumentlist "cisco",$password2
  $path = "C:\temp\ITSVENWFWL02-" + $time + ".abf"
  Write-Output $path
Set-SCPFile -ComputerName "172.16.50.101" -Credential $Credentials2 -LocalFile $path -RemotePath "/"
