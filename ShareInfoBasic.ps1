$Share = Get-SmbShare | Where-Object {$_.Name -notlike '*$'}

foreach ($s in $Share) {
    $ObjShareInfoBasic = New-Object -TypeName "ObjShareInfoBasic"
    $ObjShareInfoBasic | Add-Member -MemberType NoteProperty -Name 'ShareName' -Value $s.Name
    $ObjShareInfoBasic | Add-Member -MemberType NoteProperty -Name 'LocalPath' -Value $s.Path
}