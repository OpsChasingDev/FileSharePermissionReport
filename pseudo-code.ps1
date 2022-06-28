foreach ($Share in $ShareCollection) {
    # take the share name and iterate through NTFS and SMB permissions objects where the local paths match
    # if they match, add the ACL properties of that object to the respective object member
    $SMBCollection = @()
    foreach ($SMB in $SMBACLs) {
        if ($SMB.LocalPath -eq $Share.LocalPath) {
            $SMBobj = [PSCustomObject]@{
                AccountName = $SMB.AccountName
                AccessControlType = $SMB.AccessControlType
                AccessRight = $SMB.AccessRight
            }
        $SMBCollection += $SMBobj
        }
    }
    # add the $SMBCollection value as a member of the $Share psobject
}

<#

Output:

TypeName: FSPR_ShareInfoAdvanced

NoteProperty    ShareName [string]
NoteProperty    LocalPath [string]
NoteProperty    SMB @{AccountName,AcessControlType,AccessRight}
NoteProperty    NTFS @{AccountName,AccessControlType,AccessRight}

#>