

<#

.SYNOPSIS
This command will compare the current PSversion and return True if the current version is greater than or equal to 5.0.0.0

.DESCRIPTION
This command will compare the current PSversion and return True if the current version is greater than or equal to 5.0.0.0

.EXAMPLE
./compare-psversion.ps1

#>
#returns True is PSversion is greater than or equal to 5.0.0.0

$PSVersionTable.PSVersion -ge [Version]'5.0.0.0'
