<#
.SYNOPSIS
This cmdlet will change the name of a user in AD. 

.DESCRIPTION
This cmdlet will change the username and email of an individual in AD. The function find the user using a unique ID number, then check to see if the correct username was entered as an argument.
If both events return true then the name change is carried out.

.EXAMPLE
Rename-User -OldFirstName John -OldLastName Smith -NewFirstName John -NewLastName Doe -EmployeeID 123456
#>
function Rename-User {
    [cmdletbinding(SupportsShouldProcess=$True)]

    param (
    [Parameter (Mandatory=$true)]
    [string] $OldFirstName,
   
    [Parameter (Mandatory=$true)]
    [string] $OldLastName,
    
    [Parameter (Mandatory=$true)]
    [string] $NewFirstName,
    
    [Parameter (Mandatory=$true)]
    [string] $NewLastName,
    
    [Parameter (Mandatory=$true, HelpMessage = 'Enter Id number: xxxxxxx')]
    [ValidatePattern("^\d{2}$")]
    [Alias('StudentID','Id')]
    [string] $EmployeeID
    ) # end param

    #Checking to see if account name exist in AD
    $identity = "$OldFirstName$OldLastName"
    $newIdentity = "$NewFirstName$NewLastName"
    
    Write-Verbose "Verifying Account for $identity..."
    try{
        $user = Get-ADUser -Identity $identity -Properties * 
        if ($user){
            Write-Verbose "User: $identity found in Active Directory."
            $domain = ($user.UserPrincipalName).Substring(($user.UserPrincipalName).IndexOf('@'))
        }
    }
    catch{
        Write-Verbose "User: $identity was not found Active Directory."
        Write-Error "User: $identity was not found Active Directory. Please check input parameters and try again."
        
    }
    Write-Verbose "Checking user account ID..."
    if ($user.EmployeeID -eq  $EmployeeID){
        Write-Verbose "ID: $EmployeeID matches to account $OldFirstName$OldLastName."
    }
    else{
        Write-Verbose "ID: $EmployeeID does not match to account $OldFirstName$OldLastName."
        Write-Error "ID: $EmployeeID does not match to account $OldFirstName$OldLastName. Please check input parameters and try again."
        
    }

    try{
        Write-Verbose "##################################"
        Write-Verbose "Setting SamAccountName to $newIdentity" 
        Set-ADUser -Identity $user.ObjectGUID -SamAccountName $newIdentity
    }
    catch{
        Write-Error "Unable to set SamAccountName to new value on user"     
        
    }

    try {
        $newUser = Get-ADUser -Identity $user.ObjectGUID -Properties *
        $upn = ($newUser.SamAccountName)+$domain
        Write-Verbose "##################################"
        Write-Verbose "Setting UserPrincipalName to: $upn"
        Write-Verbose "Setting Given Name to:" #$newUser.SamAccountName
        Set-ADUser -Identity $user.ObjectGUID -UserPrincipalName $upn -GivenName $newUser.SamAccountName
    }
    catch {
        write-Error "Unable to change UPN or Given Name on user: $newIdentity. Please make sure you are using this module with elevated access."
        
    }
    try{
        Write-Verbose "Getting credentials for Exchange"
        $excred = Get-Credential -Message "Enter credentials for remote mailbox management"
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "connection point" -Credential $excred -Authentication Kerberos
        Import-PSSession $Session
    }
    catch{
        Write-Error "There was an issue with the exchange management login. Please check the credentials and make sure the accounts has permissions need to change mailbox settings."
        
    }
    try{
        Write-Verbose "Setting remote mailbox attributes on $identity" 
        Set-RemoteMailbox -Identity $identity -Alias $newIdentity -RemoteRoutingAddress $($newIdentity+"@letnet.mail.onmicrosoft.com")
    }
    catch{
        Write-Error "Unable to set new values on the remote mailbox for" $identity
        
    }

    Write-Verbose "Setting name attribute on $newIdentity" 
    Set-ADUser -Identity $user.ObjectGUID -Replace @{name="$newIdentity"}
    Write-Verbose "Setting display name attribute on $newIdentity" 
    Set-ADUser -Identity $user.ObjectGUID -Replace @{displayname="$NewLastName, $NewFirstName"}
    Write-Verbose "Setting surname attribute on $newIdentity" 
    Set-ADUser -Identity $user.ObjectGUID -Replace @{sn="$NewLastName"}
}