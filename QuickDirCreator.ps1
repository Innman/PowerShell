<#
.SYNOPSIS
This script will create MyDocument Directories and assign permissions for a group of users.

.DESCRIPTION
The script pulls users from an OU in Active Directory and create a new MyDocument folder if it does not already exist in the target directory. The script also sets folder permission for the user.

.EXAMPLE
./QuickDirCreator.ps1
#>

$dirPath = "C:\temp\"


$users = Get-ADUser -Identity testaccount

foreach ($user in $users) {

    if (!(Test-Path ($dirPath + $user.Name))) {
        New-Item -ItemType Directory -Path ($dirPath + $user.Name)
    }

    $Acl1 = Get-Acl ($dirPath + $user.Name)
    #$Acl2 = Get-Acl ($dirPath + $user.Name)
    $Ar1 = New-Object  system.security.accesscontrol.filesystemaccessrule($user.Name, "Modify", 'ContainerInherit, ObjectInherit', 'None',"Allow")
    $Ar2 = New-Object  system.security.accesscontrol.filesystemaccessrule($user.Name, "FullControl","Allow")
    #$Acl1.SetAccessRuleProtection($true,$true)

    $Acl1.SetAccessRule($Ar1)
    $Acl1.AddAccessRule($Ar2)
    Set-Acl ($dirPath + $user.Name) $Acl1
    #Set-Acl ($dirPath + $user.Name) $Acl2
}
