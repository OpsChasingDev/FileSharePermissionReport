$Share = Get-SmbShare | Where-Object {$_.Name -notlike '*$'}
$ColShareInfoBasic = @()
foreach ($s in $Share) {
    $ObjShareInfoBasic = [PSCustomObject]@{
        ShareName = $s.Name
        LocalPath = $s.Path
    }
}