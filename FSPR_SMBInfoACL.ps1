function FSPR_SMBInfoACL {
    [CmdletBinding()]
    param (
        [FSPR_ObjShareInfoBasic[]]$ShareInfo
    )
    Get-SmbShareAccess
}