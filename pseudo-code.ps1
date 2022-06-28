foreach ($Share in $ShareCollection) {
    # take the share name and iterate through NTFS and SMB permissions objects where the local paths match
    # if they match, add the ACL properties of that object to the respective object member
    $SMB_Collection = @()
    foreach ($SMB in $SMB_ACL_Collection) {
        if ($SMB.LocalPath -eq $Share.LocalPath) {
            $SMBobj = [PSCustomObject]@{
                AccountName = $SMB.AccountName
                AccessControlType = $SMB.AccessControlType
                AccessRight = $SMB.AccessRight
            }
        $SMB_Collection += $SMBobj
        }
    }
    # add the $SMB_Collection value as a member of the $Share psobject
}

<#

Output:

TypeName: FSPR_ShareInfoAdvanced

NoteProperty    ShareName [string]
NoteProperty    LocalPath [string]
NoteProperty    SMB @{AccountName,AcessControlType,AccessRight}
NoteProperty    NTFS @{AccountName,AccessControlType,AccessRight}

#>