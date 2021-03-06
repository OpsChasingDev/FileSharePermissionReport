param (
    [Parameter(ValueFromPipelineByPropertyName,
        Mandatory)]
    [string[]]$ComputerName,

    [ValidateNotNullOrEmpty()]
    [string]$ModulePath = 'C:\git\FileSharePermissionReport\FSPR.psm1',

    [string]$ModuleDestination = 'C:\Program Files\WindowsPowerShell\Modules',

    [switch]$PersistModule
)

foreach ($c in $ComputerName) {
    # open new session to remote machine
    $Session = New-PSSession -ComputerName $c -ErrorAction SilentlyContinue

    # copy module file to remote machine
    Invoke-Command -Session $Session {
        New-Item -ItemType Directory -Path "$using:ModuleDestination\FSPR" -ErrorAction SilentlyContinue > $null
    }
    $CopySplat = @{
        Path        = $ModulePath
        Destination = "$ModuleDestination\FSPR\FSPR.psm1"
        Force       = $true
        ToSession   = $Session
    }
    Copy-Item @CopySplat

    # execute script logic on remote machine
    Invoke-Command -Session $Session {
        $SMBInfoACL = FSPR_ShareInfoBasic | FSPR_SMBInfoACL
        $NTFSInfoACL = FSPR_ShareInfoBasic | FSPR_NTFSInfoACL
        $ShareInfoAdvancedSplat = @{
            SMBInfoACL = $SMBInfoACL
            NTFSInfoACL = $NTFSInfoACL
        }
        FSPR_ShareInfoBasic | FSPR_ShareInfoAdvanced @ShareInfoAdvancedSplat
    }

    # clean up and remove script files on remote machines
    if (!$PersistModule) {
        Invoke-Command -Session $Session {
            Remove-Item -Path "$using:ModuleDestination\FSPR" -Recurse -Force
        }
    }

    # close session
    Remove-PSSession -Session $Session
}