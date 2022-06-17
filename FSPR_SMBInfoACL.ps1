function FSPR_SMBInfoACL {
    [CmdletBinding()]
    param (
        [FSPR.ObjShareInfoBasic[]]$ShareInfo
    )
    Get-SmbShareAccess
}