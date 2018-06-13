#Papa can you hear me?
<#
[console]::beep(220,500)
[console]::beep(293.665,500)
[console]::beep(349.228,500)
[console]::beep(440,500)
[console]::beep(391.995,900)
[console]::beep(440,900)
#>

for ($i = 0; $i -le 10; $i++){

    [console]::beep(440,200)
    Start-Sleep -s 1

}