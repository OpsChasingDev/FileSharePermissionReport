function ShareInfoBasic {
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
    PS C:\> ShareInfoBasic      

ShareName LocalPath
--------- ---------
Root      C:\Root
.EXAMPLE
    PS C:\> ShareInfoBasic | gm

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