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
    [Alias('Name','Identity')]
    [string] $Username,

    [Parameter (Mandatory=$true)]
    [string] $Newname,

    [Parameter (Mandatory=$true)]
    [ValidatePattern("^\d{6}$")]
    [Alias('StudentID','Id','IdNumber')]
    [string] $EmployeeID
    ) # end param

    Write-Verbose "Seleced User: $Username"
    Write-Verbose "New Name: $Newname"
    Write-Verbose "ID: $EmployeeID"


    <#Find AD user with $EmployeeID and check to see if sam.accountname = $username
        If both are match the selected user from AD, change the name
        Format = Last, First

    #>
}