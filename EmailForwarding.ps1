#This script must be ran in a powershell prompt with the ActiveDirectory module installed ("get-module ActiveDirectory" should return output if installed)
#This script should run with elevated permissions that allows for writing to editing user in AD
#When prompted for credentials you should use an account that has permissions to edit 0365 mailboxes.

$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "<ConnectionURI>" -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

$users = Import-Csv -Path .\EmailForwarding.csv -Header 'Name','ExternalAddress'
foreach ($user in $users) {
    Get-ADUser -Identity $user.name | Move-ADObject -TargetPath "<Target OU>"
    Add-ADGroupMember -Identity "<GROUP NAME TO ADD>" -Members $user.name
    Set-Mailbox $user.name -ForwardingSmtpAddress $user.ExternalAddress -DeliverToMailboxAndForward $true -Verbose
}

#check to verify forwarding address is set
foreach ($user in $users) {
    get-Mailbox $user.name | Select-Object Name, ForwardingSMTPAddress, DeliverToMailboxAndForward
}
