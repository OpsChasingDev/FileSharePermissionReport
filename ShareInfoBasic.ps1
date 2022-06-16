function ShareInfoBasic {
    [OutputType('FSPR.ObjShareInfoBasic')]
    [CmdletBinding()]

    $Share = Get-SmbShare | Where-Object {$_.Name -notlike '*$'}
    $ColShareInfoBasic = @()

    foreach ($s in $Share) {
        $ObjShareInfoBasic = [PSCustomObject]@{
            PSTypeName = "FSPR.ObjShareInfoBasic"
            ShareName = $s.Name
            LocalPath = $s.Path
        }
        $ColShareInfoBasic += $ObjShareInfoBasic
    }

    Write-Output $ColShareInfoBasic
}