function FSPR_SMBInfoACL {
    <#
    .SYNOPSIS
        Gets share permissions information about non-system SMB Shares on a system.
    .DESCRIPTION
        Gets share permissions information about non-system SMB Shares on a system.

        The purpose of this fucntion is for use in the FilesharePermissionReport whereby the input used for this function is the output generated from the FSPR_ShareInfoBasic function.
    .LINK
        https://github.com/OpsChasingDev/FileSharePermissionReport
    .EXAMPLE
        Test-MyTestFunction -Verbose
        Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
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