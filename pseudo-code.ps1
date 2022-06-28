foreach ($Share in $ShareCollection) {
    # take the share name and iterate through NTFS and SMB permissions objects where the local paths match
    # if they match, add the ACL properties of that object to the 
}

<#

Output:

TypeName: FSPR_ShareInfoAdvanced

NoteProperty    ShareName [string]
NoteProperty    LocalPath [string]
NoteProperty    SMB @{AccountName,AcessControlType,AccessRight}
NoteProperty    NTFS @{AccountName,AccessControlType,AccessRight}

#>