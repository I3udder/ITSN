#----- define parameters -----#
#----- get current date ----#
$Now = Get-Date
$time = get-date -format yyyyMMdd-HHmmss
#----- define amount of days ----#
$Days = "14"
#----- define folder where files are located ----#
$TargetFolder = "C:\SSH-Root\Backup"
#----- define extension ----#
$Extension = "*.conf"
#----- define LastWriteTime parameter based on $Days ---#
$LastWrite = $Now.AddDays(-$Days)
#----- define log file for delete actions
$path = "C:\SSH-Root\Backup\Switch-Backup-" + $time + ".txt"


Start-Transcript -Path $path -NoClobber
 
#----- get files based on lastwrite filter and specified folder ---#
$Files = Get-Childitem $TargetFolder -Include $Extension -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}
 
foreach ($File in $Files) 
    {
    if ($File -ne $NULL)
        {
        write-host "Deleting File $File `r`n"
        Remove-Item $File.FullName | out-null
        }
    else
        {
        Write-Host "No more files to delete! `r`n"
        }
    }

Stop-Transcript