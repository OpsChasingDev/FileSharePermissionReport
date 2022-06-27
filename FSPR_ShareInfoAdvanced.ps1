function FSPR_ShareInfoAdvanced {
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
        $obj = [PSCustomObject]@{
            PSTypeName = 'FSPR.ObjShareInfoAdvanced'
            ComputerName = $env:COMPUTERNAME
            ShareName = $_.ShareName
            LocalPath = $_.LocalPath
            Permission = $Permission
        }
        Write-Output $obj
    }

    END {}
}