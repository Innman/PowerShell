$ids = get-content -Path separations-id.csv

foreach ($id in $ids) {
    $user = Get-ADUser -Filter {employeeid -eq $id} 
    $user | Out-File C:\Users\NickFaul\Downloads\output.txt -Append
    Disable-ADAccount -Identity $user.name
    # The -confirm:$false flag is set to not prompt for confirmation
    Get-ADUser -Identity $user.name -Properties * | Select-Object -ExpandProperty memberof | Remove-ADGroupMember -Members $user.name -Confirm:$false
}

