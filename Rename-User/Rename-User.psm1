<#
.SYNOPSIS
This cmdlet will change the name of a user in AD. 

.DESCRIPTION
This cmdlet will change the username and email of an individual in AD. The function find the user using a unique ID number, then check to see if the correct username was entered as an argument.
If both events return true then the name change is carried out.

.EXAMPLE
Rename-User -identity "John Smith" -Newname "John Doe" -EmployeeID "123456"
#>
function Rename-User {
    [cmdletbinding()]

    param (
    [Parameter (Mandatory=$true)]
    [string] $OldFirstName,
   
    [Parameter (Mandatory=$true)]
    [string] $OldLastName,
    
    [Parameter (Mandatory=$true)]
    [string] $NewFirstName,
    
    [Parameter (Mandatory=$true)]
    [string] $NewLastName,
    
    [Parameter (Mandatory=$true, HelpMessage = 'Enter Id number: xxxxxx')]
    [ValidatePattern("^\d{6}$")]
    [Alias('StudentID','Id')]
    [string] $EmployeeID
    ) # end param

    #Checking to see if account name exist in AD
    $identity = "$OldFirstName$OldLastName"

    Write-Verbose "Verifying Account for $identity..."
    try{
        $user = Get-ADUser -Identity $identity -Properties * 
        if ($user){
            Write-Verbose "User: $identity found in Active Directory."
        }
    }
    catch{
        Write-Verbose "User: $identity was not found Active Directory."
        Write-Error "User: $identity was not found Active Directory. Please check input parameters and try again."
        exit
    }
    
    Write-Verbose "Checking user account ID..."
    if ($user.EmployeeID -eq  $EmployeeID){
        Write-Verbose "ID: $EmployeeID matches to account $OldFirstName$OldLastName."
    }
    else{
        Write-Verbose "ID: $EmployeeID does not match to account $OldFirstName$OldLastName."
        Write-Error "ID: $EmployeeID does not match to account $OldFirstName$OldLastName. Please check input parameters and try again."
        exit
    }

    <#Find AD user with $EmployeeID and check to see if sam.accountname = $username
        If both are match the selected user from AD, change the name
        Format = Last, First

    #>
    
}