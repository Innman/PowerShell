<#.SYNOPSIS
This cmdlet will change the name of a user in AD. 

.DESCRIPTION
This cmdlet will change the name of and email of a user in AD.
.EXAMPLE
./Rename-LETUUser.ps1
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

    Write-Verbose "Verifying Account for $OldLastName, $OldFirstName.."
    Write-Verbose "Checking user account ID..."
    Write-verbose "ID: $EmployeeID matches to account $OldFirstName$OldLastName."
}