# constructor script intended to be invoked to other machines for processing their share data permissions
function FSPR_ShareInfoBasic {
    <#
    .SYNOPSIS
        Retrieves basic information about non-system SMB Shares on a system.
    .DESCRIPTION
        Retrieves basic information about non-system SMB Shares on a system.

        The purpose of this function is for use in the FileSharePermissionReport whereby the first step in the process is to identify every non-system SMB share and return only the share name and local path.
    .LINK
        https://github.com/OpsChasingDev/FileSharePermissionReport
    .OUTPUTS
        FSPR.ObjShareInfoBasic
    .EXAMPLE
        PS C:\> FSPR_ShareInfoBasic      

    ShareName LocalPath
    --------- ---------
    Root      C:\Root
    .EXAMPLE
        PS C:\> FSPR_ShareInfoBasic | gm

    TypeName: FSPR.ObjShareInfoBasic

    Name        MemberType   Definition
    ----        ----------   ----------
    Equals      Method       bool Equals(System.Object obj)
    GetHashCode Method       int GetHashCode()
    GetType     Method       type GetType()
    ToString    Method       string ToString()
    LocalPath   NoteProperty string LocalPath=C:\Root
    ShareName   NoteProperty string ShareName=Root
    #>
    [OutputType('FSPR.ObjShareInfoBasic')]
    [CmdletBinding()]

    $Share = Get-SmbShare | Where-Object { $_.Name -notlike '*$' }
    $ColShareInfoBasic = @()

    foreach ($s in $Share) {
        $ObjShareInfoBasic = [PSCustomObject]@{
            PSTypeName = "FSPR.ObjShareInfoBasic"
            ShareName  = $s.Name
            LocalPath  = $s.Path
        }
        $ColShareInfoBasic += $ObjShareInfoBasic
    }

    Write-Output $ColShareInfoBasic
}

function FSPR_SMBInfoACL {
    <#
    .SYNOPSIS
        Gets share permissions information about non-system SMB Shares on a system.
    .DESCRIPTION
        Gets share permissions information about non-system SMB Shares on a system.

        The purpose of this fucntion is for use in the FilesharePermissionReport whereby the input used for this function is the output generated from the FSPR_ShareInfoBasic function.
    .LINK
        https://github.com/OpsChasingDev/FileSharePermissionReport
    .OUTPUTS
        FSPR.ObjSMBInfoACL
    .EXAMPLE
        PS C:\> FSPR_ShareInfoBasic | FSPR_SMBInfoACL
        
        Takes the output FSPR_ShareInfoBasic and feeds this as input to FSPR_SMBInfoACL.  The output generated is a unique object containing information about each SMB permission for each non-system share found.
    #>
    [OutputType('FSPR.ObjSMBInfoACL')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline,
            Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames -eq 'FSPR.ObjShareInfoBasic' })]
        [System.Object]$ShareInfo
    )

    BEGIN {}

    PROCESS {
        $SMBACL = Get-SmbShareAccess -Name $ShareInfo.ShareName
        foreach ($acl in $SMBACL) {
            $obj = [PSCustomObject]@{
                PSTypeName        = "FSPR.ObjSMBInfoACL"
                ShareName         = $ShareInfo.Sharename
                ShareLocalPath    = $ShareInfo.LocalPath
                AccountName       = $acl.AccountName
                AccessControlType = $acl.AccessControlType
                AccessRight       = $acl.AccessRight
            }
            Write-Output $obj
        }
    }
    
    END {}
}

function FSPR_NTFSInfoACL {
    <#
    .SYNOPSIS
        Gets NTFS permissions information about local paths belonging to non-system SMB Shares on a system.
    .DESCRIPTION
        Gets NTFS permissions information about local paths belonging to non-system SMB Shares on a system.

        The purpose of this fucntion is for use in the FilesharePermissionReport whereby the input used for this function is the output generated from the FSPR_ShareInfoBasic function.
    .LINK
        https://github.com/OpsChasingDev/FileSharePermissionReport
    .OUTPUTS
        FSPR.ObjSMBInfoACL
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

$SMBJob = FSPR_ShareInfoBasic | FSPR_SMBInfoACL
$NTFSJob = FSPR_ShareInfoBasic | FSPR_NTFSInfoACL