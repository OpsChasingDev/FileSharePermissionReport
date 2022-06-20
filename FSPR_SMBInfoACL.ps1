function FSPR_SMBInfoACL {
    [OutputType('FSPR.ObjSMBInfoACL')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [ValidateScript({$_.PSObject.TypeNames -eq 'FSPR.ObjShareInfoBasic'})]
        [System.Object[]]$ShareInfo
    )
    $SMBACL = Get-SmbShareAccess -Name $ShareInfo.ShareName
}