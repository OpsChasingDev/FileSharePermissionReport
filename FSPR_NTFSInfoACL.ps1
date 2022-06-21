function FSPR_NTFSInfoACL {
    [OutputType('FSPR.ObjNTFSInfoACL')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline,
            Mandatory)]
            [ValidateScript({ $_.PSObject.TypeNames -eq 'FSPR.ObjShareInfoBasic' })]
            [System.Object]$NTFSInfo
    )
}