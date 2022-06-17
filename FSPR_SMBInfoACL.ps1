function FSPR_SMBInfoACL {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [ValidateScript({$_.PSObject.TypeNames -eq 'FSPR.ObjShareInfoBasic'})]
        $ShareInfo
    )
    Write-Output $ShareInfo
}