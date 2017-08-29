$time = get-date -format yyyyMMdd
$timeYesterday = (get-date).AddDays(-1).ToString("yyyyMMdd")
$TargetFolder = "C:\SSH-Root\Backup\"
$Extension = "*.conf"
$TempFile = "C:\temp\Changelog.txt"
$path = "C:\SSH-root\Backup\Compare-" + $time + ".txt"

Start-Transcript -Path $path -NoClobber

$Files = get-childitem $TargetFolder -Recurse -include $Extension | Where-Object { $_.LastWriteTime -gt (get-date).AddHours(-4)}

ForEach ($File in $Files) {
 #Write-Host $File.name.Substring(0,$File.name.Length-21)
 $Filename = $File.name.Substring(0,$File.name.Length-21) +"-"+ $timeYesterday
 $Include = ""
 $Include += $Filename
 $Include += $Extension
 Write-Output $Include
 $Files2 = get-childitem $TargetFolder -Recurse -include $Include
 ForEach ($File2 in $Files2) {
   $Output = $File2.FullName +" "+ $File.Fullname
   Write-Output $Output
   $Compare = Compare-Object $(Get-Content $File.FullName) $(Get-Content $File2.FullName)
   If (!($compare)) {
     Write-Output "No changes found"
     }
   Else {
     Write-Output $Compare
     $compare | Out-File $TempFile
     $Subject = "Change found in "+ $File.name
     $Body = "For complete changelog see attachement. We compared "+ $File.name +" and "+ $file2.name
     Send-MailMessage -From "helpdesk@itsn.nl" -To "j.vercoulen@itsn.nl" -Subject $Subject -Body $Body -Attachments $TempFile -dno onSuccess, onFailure -SmtpServer "192.168.99.20"
     Remove-Item $TempFile
   }
   Write-Output "Finished"
 }
}
Stop-Transcript

