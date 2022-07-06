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

    $Share = Get-SmbShare | Where-Object {
        $_.Name -notlike '*$' -and
        $_.Volume -like '\\*' -and
        $_.Name -ne 'SYSVOL' -and
        $_.Name -ne 'NETLOGON'
    }
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

        The purpose of this function is for use in the FilesharePermissionReport whereby the input used for this function is the output generated from the FSPR_ShareInfoBasic function.
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
        [System.Object]$SMBInfo
    )

    BEGIN {}

    PROCESS {
        $SMBACL = Get-SmbShareAccess -Name $SMBInfo.ShareName
        foreach ($acl in $SMBACL) {
            $obj = [PSCustomObject]@{
                PSTypeName        = "FSPR.ObjSMBInfoACL"
                ShareName         = $SMBInfo.Sharename
                ShareLocalPath    = $SMBInfo.LocalPath
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

        The purpose of this function is for use in the FilesharePermissionReport whereby the input used for this function is the output generated from the FSPR_ShareInfoBasic function.
    .LINK
        https://github.com/OpsChasingDev/FileSharePermissionReport
    .OUTPUTS
        FSPR.ObjNTFSInfoACL
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

function FSPR_ShareInfoAdvanced {
    <#
    .SYNOPSIS
        Consolidates SMB and NTFS permissions for non-system shares in a single object.
    .DESCRIPTION
        Consolidates SMB and NTFS permissions for non-system shares in a single object.

        The purpose of this function is for use in the FilesharePermissionReport whereby the output information of FSPR_NTFSInfoACL and FSPR_SMBInfoACL are called in this function via a constructor in order to combine both types of permissions information.
    .LINK
        https://github.com/OpsChasingDev/FileSharePermissionReport
    .OUTPUTS
        FSPR.ObjShareInfoAdvanced
    .EXAMPLE
        Invoke-Command -Session $Session {
        $SMBInfoACL = FSPR_ShareInfoBasic | FSPR_SMBInfoACL
        $NTFSInfoACL = FSPR_ShareInfoBasic | FSPR_NTFSInfoACL
        $ShareInfoAdvancedSplat = @{
            SMBInfoACL = $SMBInfoACL
            NTFSInfoACL = $NTFSInfoACL
        }
        FSPR_ShareInfoBasic | FSPR_ShareInfoAdvanced @ShareInfoAdvancedSplat
    }

        Output:

        Extracted from an example constructor.  Creates a remote session to a computer that will return one object per non-system share on the computer.  Each object will have an SMB member and an NTFS member, both of which are a collection of the respective permissions information for that share.  The below is an example of such an output:

        ComputerName   : SL-DC-01
ShareName      : TestShares
LocalPath      : D:\TestShares
SMB            : {@{AccountName=Everyone; AccessControlType=Allow; AccessRight=Full}}
NTFS           : {@{AccountName=BUILTIN\Administrators; AccessControlType=Allow;
                 AccessRight=FullControl}, @{AccountName=SAVYLABS\User-008; AccessControlType=Allow;
                 AccessRight=FullControl}, @{AccountName=BUILTIN\Administrators;
                 AccessControlType=Allow; AccessRight=FullControl}, @{AccountName=NT AUTHORITY\SYSTEM;
                 AccessControlType=Allow; AccessRight=FullControl}…}
PSComputerName : sl-dc-01
RunspaceId     : 858bd868-91e1-4d7a-a6d8-d99dd245414e
    #>
    [OutputType('FSPR.ObjShareInfoAdvanced')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline,
            Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames -eq 'FSPR.ObjShareInfoBasic' })]
        [System.Object]$ShareInfo,

        [Parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames -eq 'FSPR.ObjSMBInfoACL' })]
        [System.Object]$SMBInfoACL,

        [Parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames -eq 'FSPR.ObjNTFSInfoACL' })]
        [System.Object]$NTFSInfoACL
    )

    BEGIN {}

    PROCESS {
        # object and array creations
        $SMB_Collection = @()
        $NTFS_Collection = @()
        $obj = [PSCustomObject]@{
            PSTypeName = 'FSPR.ObjShareInfoAdvanced'
            ComputerName = $env:COMPUTERNAME
            ShareName = $_.ShareName
            LocalPath = $_.LocalPath
        }
        
        # adding SMB ACLs to the respective array
        foreach ($SMB in $SMBInfoACL) {
            if ($SMB.ShareLocalPath -eq $_.LocalPath) {
                $SMB_obj = [PSCustomObject]@{
                    AccountName = $SMB.AccountName
                    AccessControlType = $SMB.AccessControlType
                    AccessRight = $SMB.AccessRight
                }
            $SMB_Collection += $SMB_obj
            }
        }
        
        # adding NTFS ACLs to the respective array
        foreach ($NTFS in $NTFSInfoACL) {
            if ($NTFS.ShareLocalPath -eq $_.LocalPath) {
                $NTFS_obj = [PSCustomObject]@{
                    AccountName = $NTFS.AccountName
                    AccessControlType = $NTFS.AccessControlType
                    AccessRight = $NTFS.AccessRight
                }
            $NTFS_Collection += $NTFS_obj
            }
        }

        # add each ACL array as a value to its own member of the output object
        $obj | Add-Member -Name "SMB" -MemberType NoteProperty -Value $SMB_Collection
        $obj | Add-Member -Name "NTFS" -MemberType NoteProperty -Value $NTFS_Collection
        Write-Output $obj
    }

    END {}
}