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
    [Alias('Name','Identity')]
    [string] $Username,
    [string] $Newname,
    [Parameter (Mandatory=$true,HelpMessage = 'Return all computers matching this prefix, e.g., lh-133')]
    [ValidatePattern("^\d{6}$")]
    [Alias('StudentID','Id')]
    [string] $EmployeeID
    ) # end param

    Write-Host "Doing Stuff"
    Write-Verbose "Doing verbose stuff with $Username"
}