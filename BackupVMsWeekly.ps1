# I looked for a way to compress and encrypt using password, and 7z was the most recommended way 
# We use the code from below link to copy only one disk (for the special cases)
# https://stackoverflow.com/questions/14207788/accessing-volume-shadow-copy-vss-snapshots-from-powershell
#Password for encrypting files to Google

#Need to remove this for parameter block
$FilePassword="Password"

# In Robocopy statements below, we have an IPG of 175. This seems to be about right for keeping the 
# network to 50% capacity. If we get higher bandwidth, we can experiement with this change the number

# We define some functions here.
function FullBackup {param ([string]$ServerName)
  $logTime = get-date -Format HH:mm
  "  Starting Export of VM at " + $logTime >> $LogFileName
  export-vm -name $Servername -path g:\
       ##Because of getting quotes to the 7Z command, we'll move the VHDX to g:<root>
       move-item "g:\$Servername\virtual hard disks\*.vhdx" g:\
  remove-item g:\$Servername -force -Recurse     
}

function CompressTheFiles {
  ##Here I need to enumerate all hard vhdx, and do them one by one. I need to append date to the zip filename
  $logTime = get-date -Format HH:mm
  "  Starting Compress of Files: " + $logTime >> $LogFileName
  $AllVHDXFiles=Get-ChildItem -path "g:\*.vhdx"
  foreach ($VHDXFile in $AllVHDXFiles)
  {
    $DateNow = get-date -Format yyyyMMdd
    $VHDXFileName=$VHDXFile.Name
 #If you do want to zip the files, uncomment the next 5 lines, and comment the 2 after that.
    #$ZipFileName=$VHDXFileName.replace(".vhdx","$DateNow")
    #$ZipFileName=$ZipFileName + $BackupType +  ".zipt"
    #$ZipFileNameDone=$ZipFileName.replace(".zipt",".zip")
  #& "c:\backupbatch\7z.exe" "a", "-tzip", "-mx3", "-p$FilePassword", "g:\$ZipFileName", "g:\$VHDXFileName"
    #Rename-Item g:\$ZipFileName g:\$ZipFileNameDone
  #If you do want to zip, comment the next two lines. Above 5 are uncommented for zipping.
    $TmpFileName = $VHDXFileName.replace(".vhdx","$DateNow" + ".vhdy")
    rename-item g:\$VHDXFileName g:\$TmpFileName
  }
  # Uncomment the next line if you are zipping. 
  # remove-item g:\*.vhdx
}

# My fileserver. I only worry about the changed data files, so thus I only robocopy the changed files to a temp area, and work with them.
function DoFileServerBackup {
  $logTime = get-date -Format HH:mm
  "  FileServer01 Data Files Collection Starting: " + $logTime >> $LogFileName
  cmd /c md g:\FSWeeklyDir
  $DateNow = get-date -Format yyyyMMdd
  robocopy.exe \\FileServer01\e$\ g:\FSWeeklyDir /xd `$Recycle.bin LogUserComp PITSPublic PopuliBackups ServerLogs Shares Transfer win7backups WsusContent /xj /ipg:175 /r:2 /w:2 /s /maxage:8
  $logTime = get-date -Format HH:mm  
  "    FileServer01 Data files starting to compress: " + $logTime >> $LogFileName
   $ZipFileName="FileServer01." + $DateNow + $BackupType + ".zipt"
   $ZipFileNameDone=$ZipFileName.replace(".zipt",".zip")
   & "c:\backupbatch\7z.exe" "a", "-tzip", "-mx3", "-r", "-p$FilePassword", "g:\$ZipFileName", "g:\FSWeeklyDir\*.*"
   Rename-Item g:\$ZipFileName g:\$ZipFileNameDone
   remove-item g:\FSWeeklyDir -force -Recurse
}


Set-Location c:\backupbatch
# This PS is a weekly routine. I have another for daily backups (almost identical to this), and so the two don't conflict, I set a flag (using a file).
# We're checking to see if there is another backup running. If so, wait a minute and try again
while (test-path c:\backupbatch\PSRunning.txt) {
  start-sleep -s 60
}
# Now that there is no other backup running, put our stamp on it so other backups won't run
$PSRunningFileName = "PSRunning.txt"
"Weekly Backup Running" > $PSRunningFileName
$BackupType = "W"

# We'll open the log file, and rename it at the end with todays date.
$LogFileDate = get-date -format yyyyMMdd
$LogFileName = "LogW.txt"
"Log file for server backups, dated " + $LogFileDate > $LogFileName

#We'll get all VM's
$AllVMs = get-vm -computername ServerHost1 
foreach ($VM in $AllVMs)
{
  $ThisVMNAme=$VM.name
    switch ($ThisVMName) 
    {
      "Server1" {
        $logTime = get-date -Format HH:mm          
        "Server1 backup starting: " + $logTime >> $logfilename
        FullBackup "Server1"
        CompressTheFiles
      }
      "Server2" {
        $logTime = get-date -Format HH:mm
        "Server2 backup starting: " + $logTime >> $logfilename
        FullBackup "Server2"
        CompressTheFiles
      }
      "ServerUnimportant" {} #Not being backed up, but is running
      "ServerNotRunning" {}  #Not running

      #FileServer is a special case
      # This server has multiple VHDX (OS, data, etc). The following creates a shadowcopy of the disk where the VM's (and VHDX's) are stored.
      # Then I just robocopy the VHDX that I want. This is not as clean as the Fullbackup function above, but workable.
      "FileServer01" {
          $logTime = get-date -Format HH:mm          
          "FileServerOS backup starting: " + $logTime >> $LogFileName
          $s1=(Get-WmiObject -List win32_shadowcopy).create("F:\", "ClientAccessible")
          $s2=Get-WmiObject win32_shadowcopy | Where-Object {$_.ID -eq $s1.shadowid}
          $d = $s2.deviceobject+"\"
          cmd /c mklink /d f:\shadowcopy "$d"
          Robocopy.exe "f:\shadowcopy\FileServer01\FileServer01\virtual hard disks" g:\ FileServer01.vhdx
          $s2.delete()
        #remove-item kicked out an error. RD doesn't
          cmd /c rd f:\shadowcopy
          Rename-Item g:\fileserver01.vhdx g:\fileserver01OS.vhdx
          CompressTheFiles
        # Now we look through the data disk, and copy/7z what we need.
        # We can do incremental backup on the data disk.
        DoFileServerBackup
      }
      "ServerDailyBackup" {} #Daily
      default {
        "**This VM is not set up yet:** " + $ThisVMNAme >> $LogFileName
      }
    }
}
$SMTPUserName="username@domain.com"
$SMTPPassword= convertto-securestring "SpecialUserPassword" -asplaintext -force
$SMTPCreds= New-Object -TypeName pscredential -ArgumentList $SMTPUserName, $SMTPPassword
$SMTPBody="See attached Log File"
$SMTPSubject="Weekly Backup Log results"
$SMTPAttachment="c:\backupbatch\" + $LogFileName
Send-MailMessage -From "ServerHostBackup@domain.com" -to "system@domain.com" -subject $SMTPSubject `
-Body $SMTPBody -SmtpServer "smtp.gmail.com" -Port "587" -UseSsl -Credential $SMTPCreds `
-Attachments $SMTPAttachment

# Remove our stamp on the running file so another Powershell backup can begin (if it's waiting)
remove-item $PSRunningFileName
