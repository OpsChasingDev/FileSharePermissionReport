function FSPR_NTFSInfoACL {
    [OutputType('FSPR.ObjShareInfoAdvanced')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline,
            Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames -eq 'FSPR.ObjShareInfoBasic' })]
        [System.Object]$ShareInfo
    )

    BEGIN {}

    PROCESS {
    
    }

    END {}
}