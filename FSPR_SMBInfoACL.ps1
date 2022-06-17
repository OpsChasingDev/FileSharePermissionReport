function FSPR_SMBInfoACL {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [FSPR.ObjShareInfoBasic[]]$ShareInfo
    )
    Get-SmbShareAccess
}