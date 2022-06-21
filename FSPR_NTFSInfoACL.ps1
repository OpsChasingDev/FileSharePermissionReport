function FSPR_NTFSInfoACL {
    <#
    .SYNOPSIS
        Gets NTFS permissions information about local paths belonging to non-system SMB Shares on a system.
    .DESCRIPTION
        Gets NTFS permissions information about local paths belonging to non-system SMB Shares on a system.

        The purpose of this fucntion is for use in the FilesharePermissionReport whereby the input used for this function is the output generated from the FSPR_ShareInfoBasic function.
    .LINK
        https://github.com/OpsChasingDev/FileSharePermissionReport
    .EXAMPLE
        PS C:\> FSPR_ShareInfoBasic | FSPR_NTFSInfoACL

        Takes the output FSPR_ShareInfoBasic and feeds this as input to FSPR_SMBInfoACL.  The output generated is a unique object containing information about each NTFS permission for each local path belonging to a non-system SMB Share.
    #>
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