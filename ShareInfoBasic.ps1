<#
.SYNOPSIS
    Retrieves basic information about non-system SMB Shares on a system.
.DESCRIPTION
    Retrieves basic information about non-system SMB Shares on a system.
    The purpose of this function is for use in the FileSharePermissionReport whereby the first step in the process is to identify every non-system SMB share and return only the share name and local path.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    https://github.com/OpsChasingDev/FileSharePermissionReport
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>

{0}
function ShareInfoBasic {
    [OutputType('FSPR.ObjShareInfoBasic')]
    [CmdletBinding()]

    $Share = Get-SmbShare | Where-Object {$_.Name -notlike '*$'}
    $ColShareInfoBasic = @()

    foreach ($s in $Share) {
        $ObjShareInfoBasic = [PSCustomObject]@{
            PSTypeName = "FSPR.ObjShareInfoBasic"
            ShareName = $s.Name
            LocalPath = $s.Path
        }
        $ColShareInfoBasic += $ObjShareInfoBasic
    }

    Write-Output $ColShareInfoBasic
}