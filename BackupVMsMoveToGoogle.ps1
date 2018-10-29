# I'll start this and let it run forver. There is a 5 minute wait period after each loop of zip files
# This uses a program called gdrive from: https://github.com/prasmussen/gdrive
# This link shows how to authenticate with Google: http://olivermarshall.net/how-to-upload-a-file-to-google-drive-from-the-command-line/

Set-Location c:\backupbatch

while ($true) {
  # If you zipped files in the actual backup PS file, then this will work. Otherwise change the "zip" part to "VHDY"
  # Or if you have a mix of zip and VHDY, you can do multiple loops.

  $AllZipFiles=Get-ChildItem -path "g:\*.zip"
  foreach ($ZipFile in $AllZipFiles)
  {
    $ZipFileName=$ZipFile.name
    $logTime = get-date -Format HH:mm  
    #$ZipFileName + " begin upload: " + $logTime > 'Upload.txt'
    $EMailBody = $ZipFileName + " Start: " + $logtime
    do {
      & "c:\backupbatch\gdrive-windows-x64" "upload", "--delete", "h:\$ZipFileName"
    } while (test-path h:\$ZipFileName)

    $logTime = get-date -Format HH:mm  
    $EMailBody = $EMailBody + ", end: " + $logTime
    $Username = "SpecialUser@prairie.edu"
    $pass = convertto-securestring "SpecialUserPassword" -asplaintext -force
    $mycreds = new-object -typename PSCredential -Argumentlist $UserName, $pass
    $SubjectTitle = "Backup to GDrive results for " + $ZipFileName
    send-mailmessage -From "ServerHostBackup@prairie.edu" -to "system@prairie.edu" -subject $SubjectTitle `
    -Body $emailbody -SmtpServer "smtp.gmail.com" -port "587" -UseSsl -Credential $mycreds 
    
  }
  start-sleep -s 300 # 300 seconds is 5 minutes
}