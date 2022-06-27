function FSPR_NTFSInfoACL {
    [OutputType('FSPR.ObjShareInfoAdvanced')]
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
        foreach ($acl in $NTFSACL.Access) {
            $obj = [PSCustomObject]@{
                PSTypeName        = "FSPR.ObjNTFSInfoACL"
                ShareLocalPath    = $NTFSInfo.LocalPath
                AccountName       = $acl.IdentityReference
                AccessControlType = $acl.AccessControlType
                AccessRight       = $acl.FileSystemRights
            }
            Write-Output $obj
        }
    }

    END {}
}