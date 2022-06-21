function FSPR_NTFSInfoACL {
    [OutputType('FSPR.ObjNTFSInfoACL')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline,
            Mandatory)]
            [ValidateScript({ $_.PSObject.TypeNames -eq 'FSPR.ObjShareInfoBasic' })]
            [System.Object]$NTFSInfo
    )

    BEGIN {}

    PROCESS {
        $NTFSACL = Get-ACL -Path $NTFSInfo.LocalPath
        foreach ($acl in $NTFSACL) {
            $obj = [PSCustomObject]@{
                PSTypeName = "FSPR.ObjNTFSInfoACL"
                ShareLocalPath = $NTFSInfo.LocalPath
                ACL = $acl.
            }
        }
    }

    END {}
}