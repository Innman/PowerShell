<#
.SYNOPSIS
This cmdlet will change the name of a user in AD. 

.DESCRIPTION
This cmdlet will change the name of and email of a user in AD.
.EXAMPLE
./Rename-User.ps1
#>



function Rename-User {
    [cmdletbinding()]
    param (
    [Alias('Name','Identity')]
    [string] $Username,

    [string] $Newname,

    [Parameter (Mandatory=$true)]
    [ValidatePattern("^\d{6}$")]
    [Alias('StudentID','Id')]
    [string] $EmployeeID
    ) # end param

    Write-Host "Doing Stuff"
    Write-Verbose "Doing verbose stuff with $Username"
}