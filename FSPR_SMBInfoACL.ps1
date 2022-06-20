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