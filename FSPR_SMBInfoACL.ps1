function FSPR_SMBInfoACL {
    [OutputType('FSPR.ObjSMBInfoACL')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [ValidateScript({$_.PSObject.TypeNames -eq 'FSPR.ObjShareInfoBasic'})]
        [System.Object]$ShareInfo
    )
    BEGIN {}
    PROCESS {
        $SMBACL = Get-SmbShareAccess -Name $ShareInfo.ShareName
        foreach ($acl in $SMBACL) {
            $obj = [PSCustomObject]@{
                PSTypeName = "FSPR.ObjSMBInfoACL"
                ShareName = 
                ShareLocalPath = 
                AccountName = 
                AccessControlType = 
                AccessRight = 
            }
            Write-Output $acl
        }
    }
    END {}
}